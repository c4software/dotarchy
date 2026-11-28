#!/usr/bin/env bash
# Clavier : Bépo Dev (session), Bépo (TTY et SDDM), NuPhy, clavier Apple.
# Installation bepoDev pour l'utilisateur
echo "Installing Bépo Dev keyboard layout (Utilisateur)..."
mkdir -p ~/.config/xkb/symbols ~/.config/xkb/rules || true
wget https://raw.githubusercontent.com/c4software/bepo_developpeur/master/linux/bepoDev -O ~/.config/xkb/symbols/bepoDev || true
wget https://raw.githubusercontent.com/c4software/bepo_developpeur/master/linux/evdev.lst -O ~/.config/xkb/rules/evdev.lst || true
wget https://raw.githubusercontent.com/c4software/bepo_developpeur/master/linux/evdev.xml -O ~/.config/xkb/rules/evdev.xml || true
[ -L ~/.config/xkb/rules/base.lst ] || ln -s ~/.config/xkb/rules/evdev.lst ~/.config/xkb/rules/base.lst || true
[ -L ~/.config/xkb/rules/base.xml ] || ln -s ~/.config/xkb/rules/evdev.xml ~/.config/xkb/rules/base.xml || true

# Bépo standard hors session (TTY et login SDDM) ; bepoDev reste pour la session.
# --no-convert : sinon chaque commande localectl écrase le réglage de l'autre.
# Hyprland hérite de XKBVARIANT : customisation.lua le remet à vide pour bepoDev.
sudo localectl --no-convert set-keymap fr-bepo
sudo localectl --no-convert set-x11-keymap fr pc105 bepo terminate:ctrl_alt_bksp

# NuPhy (accès udev) et clavier Apple (Alt/Super et Fn/Ctrl inversés)
echo "Creating /etc/udev/rules.d/50-nuphy.rules..."
sudo tee /etc/udev/rules.d/50-nuphy.rules >/dev/null <<'EOF'
# NuPhy keyboards
SUBSYSTEM=="usb", ATTR{idVendor}=="19f5", MODE="0666", GROUP="input"
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="19f5", MODE="0666", GROUP="input"
EOF

# Reload udev rules
echo "Reloading udev rules..."
sudo udevadm control --reload-rules
sudo udevadm trigger

# Apple keyboard key swapping
echo "Swapping left alt and left super keys..."
echo "options hid_apple swap_opt_cmd=1 swap_fn_leftctrl=1" | sudo tee /etc/modprobe.d/hid_apple.conf
limine-update
