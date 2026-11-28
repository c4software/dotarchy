#!/usr/bin/env bash
# Bureau : thème, plugin alt-tab, configuration Hyprland, veille du shell.
SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

# Copy the « Mix Light / Dark » theme to the Omarych Theme folder
cp -R "$SCRIPT_DIR/../archlinux/install/tilling/config/themes/mix-light-dark" ~/.config/omarchy/themes

# Installation plugin alt-tab
omarchy plugin add https://github.com/c4software/hyprland-alttab --enable

# Move default configuration for hyprland
echo "Move default configuration for Hyprland"
cp "$SCRIPT_DIR"/configs/hypr/* ~/.config/hypr/

# Require customisation.lua from hyprland.lua if not already present
grep -q '^require("hypr.customisation")' ~/.config/hypr/hyprland.lua || echo 'require("hypr.customisation")' >>~/.config/hypr/hyprland.lua

# Idle : screensaver après 4h, lock après 6h (remplace l'ancien hypridle.conf)
jq '.idle.screensaver = 14400 | .idle.lock = 21600' ~/.config/omarchy/shell.json >~/.config/omarchy/shell.json.tmp && mv ~/.config/omarchy/shell.json.tmp ~/.config/omarchy/shell.json
