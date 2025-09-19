#!/bin/bash

set -eE

# Must be on archlinux
if ! command -v pacman &> /dev/null; then
    echo "This script is intended to be run on Arch Linux." >&2
    exit 1
fi

# Update common configuration files
source ./common/install/bootstrap.sh

# Update Hyprland (without reinstalling packages)
./archlinux/install/hyprland/setup.sh --skip-packages