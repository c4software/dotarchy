#!/bin/bash

clear

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Force the script to be executed from its directory (since init.sh move us to /tmp during yay installation)
cd "$SCRIPT_DIR" || exit

# Add local bin to PATH (since we installed binaries there)
export PATH="$HOME/.local/bin:$PATH"

# Installation des scripts dans ~.local/bin
mkdir -p ~/.local/bin
cp "$SCRIPT_DIR/bin/"* ~/.local/bin/

# Download all packages using pacman for install/**/packages.txt (excluding the tilling since its optional)
find "$SCRIPT_DIR/install/" -prune -o -name "packages.txt" -exec sh -c 'grep -v "^#" "$1" | sudo pacman -S --noconfirm --needed -' _ {} \;

# Source all script under install/system with confirmation
if gum confirm "Do you want to run system setup scripts?"; then
  for script in "$SCRIPT_DIR/install/"*.sh; do
    (
      source "$script"
      setup
    )
  done
fi