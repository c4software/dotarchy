#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eE

# Init Configuration
(
    source "./common/install/bootstrap.sh"
    setup
)

# Add .local/bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Prompt with gum to choose the folder to setup.
FOLDER=$(gum choose "archlinux" "macos" --header "Choose the setup you want to run:")

if [ -z "$FOLDER" ]; then
    echo "No folder selected. Exiting."
    exit 1
fi

# Start the setup process based on the chosen folder.
(
    source "./$FOLDER/setup.sh"
    setup
)

echo "Setup completed successfully."
echo "Please restart your computer to apply all changes."