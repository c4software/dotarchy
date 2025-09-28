
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check for --skip-packages flag
if [ "$1" != "--skip-packages" ]; then
    echo -e "Installing Hyprland"

    # Install with pacman the packages.txt
    grep -v "^#" "$SCRIPT_DIR/packages.txt" | sudo pacman -S --noconfirm --needed -

    # Install with yay the packages.aur.txt
    grep -v "^#" "$SCRIPT_DIR/packages.aur.txt" | yay -S --noconfirm --needed -

    source "$SCRIPT_DIR/greetd.sh"
fi

echo -e "Moving configuration files (replace if exists)"
rm -rf ~/.config/hypr
cp -r "$SCRIPT_DIR/config/"* ~/.config/

echo -e "Moving extra bin scripts"
mkdir -p ~/.local/bin # Ensure the directory exists
cp -r "$SCRIPT_DIR/bin/"* ~/.local/bin/

# Apply the osaka-jade theme by default
# Si .config/theme is already a symlink skip this step
if [ ! -L ~/.config/theme ]; then
    if [ -d ~/.config/theme ]; then
        rm -rf ~/.config/theme
    fi
fi

# Apply the default theme
omarchy-theme-set "osaka-jade"

# Check if iwd is enabled
if ! systemctl is-enabled iwd.service >/dev/null 2>&1; then
    echo -e "Enabling and starting iwd"
    sudo systemctl enable iwd.service --now
fi

hyprctl reload # Reload Hyprland to apply changes