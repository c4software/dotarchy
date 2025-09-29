#!/bin/bash

# Usage: ./update-configs-only.sh [--all]
# If --all is provided, it will also update common configuration files.

set -eE

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