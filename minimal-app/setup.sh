#!/bin/bash

clear

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Force the script to be executed from its directory (since init.sh move us to /tmp during yay installation)
cd "$SCRIPT_DIR" || exit

# Add local bin to PATH (since we installed binaries there)
export PATH="$HOME/.local/bin:$PATH"

# Download all packages using pacman for install/**/packages.txt (excluding the tilling since its optional)
grep -v "^#" "./install/packages.txt" | sudo pacman -S --noconfirm --needed -
grep -v "^#" "./install/packages.aur.txt" | yay -S --noconfirm --needed -

# Source all script under install/system with confirmation
if gum confirm "Do you want to run app setup scripts?"; then
  for script in "$SCRIPT_DIR/install/"*.sh; do
    (
      source "$script"
      setup
    )
  done
fi
