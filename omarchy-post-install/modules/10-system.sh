#!/usr/bin/env bash
# Système : paquets de base, services coupés, modules noyau, logind, SDDM.
SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

sudo pacman -Sy --noconfirm wget

# ~/.local/bin n'existe pas sur une fresh install Omarchy
mkdir -p ~/.local/bin

# Uninstall some extra default application
sudo pacman -Rsnc 1password-beta 1password-cli chromium --noconfirm || true

# Installation de hunspell-fr
sudo pacman -Sy hunspell-fr --noconfirm

# Create a vim alias
sudo ln -sf /usr/bin/nvim /usr/bin/vim

# LocalSearch (ex-Tracker3, tiré par nautilus) : indexeur de fichiers coupé.
# Il indexe projets, SDK et node_modules (index de plusieurs Go dans
# ~/.cache/tracker3) et tourne pendant les compilations. La recherche Nautilus
# marche sans, en parcourant le disque. Réactiver :
# systemctl --user unmask --now localsearch-3.service
systemctl --user mask --now localsearch-3.service
rm -rf ~/.cache/tracker3

echo -e "\nConfiguring uhid module to fix BLE mouse issue..."
echo -e "# Fix BLE mouse issue\nuhid" | sudo tee /etc/modules-load.d/uhid.conf

# Sur secteur, capot fermé ne suspend plus (réveil à distance possible)
sudo cp "$SCRIPT_DIR/configs/logind-lid-remote-wake.conf" /etc/systemd/logind.conf.d/30-lid-remote-wake.conf
sudo systemctl kill -s HUP systemd-logind

# Enable autologin
sudo cp "$SCRIPT_DIR/configs/sddm-autologin.conf" /etc/sddm.conf.d/autologin.conf
sudo sed -i "s/USERNAME$/$USER/" /etc/sddm.conf.d/autologin.conf
