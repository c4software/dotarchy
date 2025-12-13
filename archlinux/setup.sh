#!/bin/bash

clear

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install de base
(
  source "$SCRIPT_DIR/install/init.sh"
  setup
)

# Download all packages using pacman for install/**/packages.txt
find "$SCRIPT_DIR/install/" -name "packages.txt" -exec sh -c 'grep -v "^#" "$1" | sudo pacman -S --noconfirm --needed -' _ {} \;

# Download all packages using yay for install/**/packages.aur.txt
find "$SCRIPT_DIR/install/" -name "packages.aur.txt" -exec sh -c 'grep -v "^#" "$1" | yay -S --noconfirm --needed -' _ {} \;

# Force the script to be executed from its directory (since init.sh move us to /tmp during yay installation)
cd "$SCRIPT_DIR" || exit

# Add local bin to PATH (since we installed binaries there)
export PATH="$HOME/.local/bin:$PATH"

# Source all script under install/system with confirmation
if gum confirm "Do you want to run system setup scripts?"; then
  for script in "$SCRIPT_DIR/install/system/"*.sh; do 
  (
    source "$script"
    setup
  )
  done
fi

# Source all script under install/apps with confirmation
if gum confirm "Do you want to run apps setup scripts?"; then
  clear
  for script in "$SCRIPT_DIR/install/apps/"*.sh; do
  (
    source "$script"
    setup
  )
  done
fi

# Source all scripts under desktop with confirmation
if gum confirm "Do you want to run desktop setup scripts?"; then
  clear
  for script in "$SCRIPT_DIR/install/desktop/"*.sh; do
  (
    source "$script"
    setup
  )
  done
fi

# Source all scripts under config with confirmation
if gum confirm "Do you want to run config setup scripts?"; then
  clear
  for script in "$SCRIPT_DIR/install/config/"*.sh; do
  (
    source "$script"
    setup
  )
  done
fi

# Asking for user confirmation before enable tilling (hyprland and niri)
if gum confirm "Do you want to install Tilling (Hyprland and Niri) and default configuration?"; then
  (
    clear
    source "$SCRIPT_DIR/install/tilling/setup.sh"
    setup
  )
fi
