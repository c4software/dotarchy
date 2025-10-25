#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eE

# Init Configuration
(
    source "./common/install/bootstrap.sh"
    setup
)

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

if command -v pacman &> /dev/null; then
    source "$SCRIPT_DIR/archlinux/setup.sh"
    source "$SCRIPT_DIR/common/install/webapp.sh"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    source "$SCRIPT_DIR/macos/setup.sh"
else
    echo "Unsupported distribution."
    exit 1
fi