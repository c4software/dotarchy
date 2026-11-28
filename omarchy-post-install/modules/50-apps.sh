#!/usr/bin/env bash
# Applications : terminaux, Neovim, OnlyOffice.
SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
COMMON="$SCRIPT_DIR/../common-no-omarchy"

# Changement taille font dans Alacritty & Foot
sed -i 's/^size = 9$/size = 10/' ~/.config/alacritty/alacritty.toml
sed -i 's/^size=9$/size=10/' ~/.config/foot/foot.ini

# Ghostty : Ctrl+Shift+T va à tmux (sa palette, comme Ctrl+K), pas un nouvel onglet
grep -q '^keybind = ctrl+shift+t=' ~/.config/ghostty/config 2>/dev/null \
  || printf '\n# Ctrl+Shift+T to tmux (its palette, like Ctrl+K), not a new Ghostty tab\nkeybind = ctrl+shift+t=csi:116;6u\n' >> ~/.config/ghostty/config

# Install nvim configuration
cp "$COMMON/config/nvim/lua/config/keymaps.lua" ~/.config/nvim/lua/config/keymaps.lua
# Fichiers cachés (.env, .gitignore, …) visibles par défaut dans Neo-tree et le picker Snacks
cp "$COMMON/config/nvim/lua/plugins/neo-tree-dotfiles.lua" "$COMMON/config/nvim/lua/plugins/snacks-picker-hidden.lua" ~/.config/nvim/lua/plugins/

# OnlyOffice : barre de titre système. Avec la sienne (titlebar=custom), il se
# croit en fenêtre restaurée sous Hyprland (XWayland, maximize ignoré) et garde
# son cadre (marge, ombre, boutons) au lieu de remplir sa tuile. Il réécrit ce
# fichier en quittant : à poser OnlyOffice fermé.
oo_conf=~/.config/onlyoffice/DesktopEditors.conf
mkdir -p "${oo_conf%/*}"
if [ ! -f "$oo_conf" ]; then
  printf '[General]\ntitlebar=system\n' > "$oo_conf"
elif grep -q '^titlebar=' "$oo_conf"; then
  sed -i 's/^titlebar=.*/titlebar=system/' "$oo_conf"
elif grep -q '^\[General\]' "$oo_conf"; then
  sed -i '/^\[General\]/a titlebar=system' "$oo_conf"
else
  printf '[General]\ntitlebar=system\n' | cat - "$oo_conf" > "$oo_conf.new" && mv "$oo_conf.new" "$oo_conf"
fi
