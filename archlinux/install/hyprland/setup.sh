
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check for --skip-packages flag
if [ "$1" != "--skip-packages" ]; then
    echo -e "Installing Hyprland"
    # Install with yay the packages.aur.txt
    yay -S --noconfirm --needed - <"$SCRIPT_DIR/packages.aur.txt"

    source "$SCRIPT_DIR/greetd.sh"
fi

echo -e "Moving configuration files (replace if exists)"
rm -rf ~/.config/hypr
cp -r "$SCRIPT_DIR/config/"* ~/.config/

echo -e "Moving extra bin scripts"
mkdir -p ~/.local/bin # Ensure the directory exists
cp -r "$SCRIPT_DIR/bin/"* ~/.local/bin/

# Set the dark theme for GTK apps
echo -e "Setting dark theme for GTK applications"
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface icon-theme "Yaru-blue"

# Apply the osaka-jade theme by default
# Si .config/theme is already a symlink skip this step
if [ ! -L ~/.config/theme ]; then
    if [ -d ~/.config/theme ]; then
        rm -rf ~/.config/theme
    fi

    omarchy-theme-set "osaka-jade"
fi

hyprctl reload # Reload Hyprland to apply changes