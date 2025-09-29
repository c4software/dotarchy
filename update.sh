#!/bin/bash

# Usage: ./update.sh [--all]
# If --all is provided, it will also update common configuration files.

set -eE

# Add a confirmation prompt with gum since this will overwrite existing configuration files
if ! gum confirm "This will overwrite your existing configuration files. Do you want to continue?"; then
    echo "Aborting."
    exit 0
fi

# Must be on archlinux
if ! command -v pacman &> /dev/null; then
    echo "This script is intended to be run on Arch Linux." >&2
    exit 1
fi

if [ "$1" == "--all" ]; then
    # Update common configuration files
    source ./common/install/bootstrap.sh
fi

# Update Hyprland (without reinstalling packages)
(
    source ./archlinux/install/hyprland/setup.sh --skip-packages
)