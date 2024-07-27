#!/bin/bash

# Check if the script receives two arguments: the Python script and the icon (optional)
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <python_script> [icon]"
    exit 1
fi

PYTHON_SCRIPT=$1
ICON=${2:-}

# Check if PyInstaller is installed, if not, install it
if ! command -v pyinstaller &> /dev/null; then
    echo "PyInstaller not found. Installing..."
    pip install pyinstaller
fi

# Compile the Python script into an executable
echo "Compiling $PYTHON_SCRIPT..."
pyinstaller --onefile "$PYTHON_SCRIPT"

# Get the base name of the Python script without the extension
SCRIPT_NAME=$(basename "$PYTHON_SCRIPT" .py)

# Path to the executable
EXECUTABLE="dist/$SCRIPT_NAME"

# Move the executable to /usr/local/bin
sudo mv "$EXECUTABLE" /usr/local/bin/

# Ensure the executable has the correct permissions
sudo chmod +x /usr/local/bin/"$SCRIPT_NAME"

# Check if the icon exists and is a valid image file
if [ -n "$ICON" ] && [ ! -f "$ICON" ]; then
    echo "Icon file not found: $ICON"
    exit 1
fi

# If an icon is provided, move it to /usr/local/share/icons
if [ -n "$ICON" ]; then
    ICON_DIR="/usr/local/share/icons"
    # Create the directory if it doesn't exist
    if [ ! -d "$ICON_DIR" ]; then
        sudo mkdir -p "$ICON_DIR"
    fi
    sudo cp "$ICON" "$ICON_DIR/"
    ICON_PATH="$ICON_DIR/$(basename "$ICON")"
else
    ICON_PATH=""
fi

# Create a .desktop file for the executable
DESKTOP_FILE=~/.local/share/applications/"$SCRIPT_NAME".desktop

echo "Creating application shortcut at $DESKTOP_FILE..."

cat > "$DESKTOP_FILE" <<EOL
[Desktop Entry]
Version=1.0
Name=Wyse Edge
Comment=Run $SCRIPT_NAME
Exec=/usr/local/bin/$SCRIPT_NAME
Icon=$ICON_PATH
Terminal=false
Type=Application
Categories=Utility;
EOL

# Make the .desktop file executable
chmod +x "$DESKTOP_FILE"

echo "Done. You can now find and run $SCRIPT_NAME from your applications menu."
