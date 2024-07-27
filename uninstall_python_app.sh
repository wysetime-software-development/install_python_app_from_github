#!/bin/bash

# Listing installed application
# ls ~/.local/share/applications

SCRIPT_NAME="execute"
DESKTOP_ENTRY_NAME="Wyse Edge"
ICON="wyse_suite.png"

# Remove the executable from /usr/local/bin
echo "Removing the executable from /usr/local/bin..."
sudo rm /usr/local/bin/$SCRIPT_NAME

# Remove the icon from /usr/local/share/icons
echo "Removing the icon from /usr/local/share/icons..."
sudo rm /usr/local/share/icons/$ICON

# Remove the .desktop file from ~/.local/share/applications
echo "Removing the application shortcut from ~/.local/share/applications..."
rm ~/.local/share/applications/$SCRIPT_NAME.desktop

echo "$DESKTOP_ENTRY_NAME has been uninstalled."
