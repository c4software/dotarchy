#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo pacman -Sy --noconfirm wget

# Copy zsh configuration to the HOME config folder
cp -R $SCRIPT_DIR/../common-no-omarchy/config/zsh/ ~/.config/ 
cp $SCRIPT_DIR/../common-no-omarchy/default/zshrc ~/.zshrc

# If pacman is available, install zsh and zsh-completions
if command -v pacman &>/dev/null; then
  sudo pacman -Sy --noconfirm zsh zsh-completions
fi

# Force zsh startup (inspired by omarchy-zsh)
cp $SCRIPT_DIR/configs/bashrc ~/.bashrc

# Install try command
curl -sL https://raw.githubusercontent.com/c4software/try.sh/main/try.sh -o ~/.local/bin/try
chmod +x ~/.local/bin/try

# Installation proj command
curl -sL https://raw.githubusercontent.com/c4software/prj.sh/main/prj.sh -o ~/.local/bin/proj
chmod +x ~/.local/bin/proj

# Copy the « Mix Light / Dark » theme to the Omarych Theme folder
cp -R $SCRIPT_DIR/../archlinux/install/tilling/config/themes/mix-light-dark ~/.config/omarchy/themes

# Installation bepoDev pour l'utilisateur
echo "Installing Bépo Dev keyboard layout (Utilisateur)..."
mkdir -p ~/.config/xkb/symbols ~/.config/xkb/rules || true
wget https://raw.githubusercontent.com/c4software/bepo_developpeur/master/linux/bepoDev -O ~/.config/xkb/symbols/bepoDev || true
wget https://raw.githubusercontent.com/c4software/bepo_developpeur/master/linux/evdev.lst -O ~/.config/xkb/rules/evdev.lst || true
wget https://raw.githubusercontent.com/c4software/bepo_developpeur/master/linux/evdev.xml -O ~/.config/xkb/rules/evdev.xml || true
[ -L ~/.config/xkb/rules/base.lst ] || ln -s ~/.config/xkb/rules/evdev.lst ~/.config/xkb/rules/base.lst || true
[ -L ~/.config/xkb/rules/base.xml ] || ln -s ~/.config/xkb/rules/evdev.xml ~/.config/xkb/rules/base.xml || true

echo -e "\nConfiguring uhid module to fix BLE mouse issue..."
echo -e  "# Fix BLE mouse issue\nuhid" | sudo tee /etc/modules-load.d/uhid.conf

# Cp the bin/* contents to ~/.local/bin/
cp $SCRIPT_DIR/bin/* ~/.local/bin/

# Move default configuration for hyprland
echo "Move default configuration for Hyprland"
cp $SCRIPT_DIR/configs/hypr/* ~/.config/hypr/

# Uninstall some extra default application
sudo pacman -Rsnc 1password-beta 1password-cli chromium || true

# Changement taille font dans Alacritty & Foot
sed -i 's/^size = 9$/size = 10/' ~/.config/alacritty/alacritty.toml
sed -i 's/^size=9$/size=10/' ~/.config/foot/foot.ini

# Enable autologin
sudo cp "$SCRIPT_DIR/configs/sddm-autologin.conf" /etc/sddm.conf.d/autologin.conf
sudo sed -i "s/USERNAME$/$USER/" /etc/sddm.conf.d/autologin.conf

# Enable some keyboard stuff (nuphy, apple keyboard key swapping)
(
  source "$SCRIPT_DIR/keyboard.sh"
  setupssss
)
