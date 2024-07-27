#!/bin/bash

# Check if the script receives the repository URL
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <github_repo_url>"
    exit 1
fi

GITHUB_REPO_URL=$1
PYTHON_SCRIPT="main.py"
ICON="wyse_suite.png"
DESKTOP_ENTRY_NAME="Wyse Edge"

# Clone the GitHub repository
echo "Cloning the repository from $GITHUB_REPO_URL..."
git clone "$GITHUB_REPO_URL"
REPO_NAME=$(basename "$GITHUB_REPO_URL" .git)

# Change directory to the cloned repository
cd "$REPO_NAME" || exit

# Ensure the system is updated and required packages are installed
echo "Updating system and installing required packages..."
# sudo apt update
# sudo apt install -y python3-pip

# Check if PyInstaller is installed, if not, install it
if ! command -v pyinstaller &> /dev/null; then
    echo "PyInstaller not found. Installing..."
    pip3 install pyinstaller
fi

# Compile the Python script into an executable
echo "Compiling $PYTHON_SCRIPT..."
pyinstaller --onefile "$PYTHON_SCRIPT"

# Get the base name of the Python script without the extension
SCRIPT_NAME=$(basename "$PYTHON_SCRIPT" .py)

# Path to the executable
EXECUTABLE="dist/$SCRIPT_NAME"

# Move the executable to /usr/local/bin
echo "Moving the executable to /usr/local/bin..."
sudo mv "$EXECUTABLE" /usr/local/bin/

# Ensure the executable has the correct permissions
sudo chmod +x /usr/local/bin/"$SCRIPT_NAME"

# Check if the icon exists in the project directory
if [ ! -f "$ICON" ]; then
    echo "Icon file not found: $ICON"
    exit 1
fi

# Move the icon to /usr/local/share/icons
ICON_DIR="/usr/local/share/icons"
# Create the directory if it doesn't exist
if [ ! -d "$ICON_DIR" ]; then
    sudo mkdir -p "$ICON_DIR"
fi
sudo cp "$ICON" "$ICON_DIR/"
ICON_PATH="$ICON_DIR/$(basename "$ICON")"

# Create a .desktop file for the executable
DESKTOP_FILE=~/.local/share/applications/"$SCRIPT_NAME".desktop

echo "Creating application shortcut at $DESKTOP_FILE..."

cat > "$DESKTOP_FILE" <<EOL
[Desktop Entry]
Version=1.0
Name=$DESKTOP_ENTRY_NAME
Comment=Run $DESKTOP_ENTRY_NAME
Exec=/usr/local/bin/$SCRIPT_NAME
Icon=$ICON_PATH
Terminal=false
Type=Application
Categories=Utility;
EOL

# Make the .desktop file executable
chmod +x "$DESKTOP_FILE"

# Move out of the cloned directory and delete it
cd ..
rm -rf "$REPO_NAME"

echo "Done. You can now find and run $DESKTOP_ENTRY_NAME from your applications menu."
