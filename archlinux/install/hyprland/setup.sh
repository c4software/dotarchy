
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function setup() {
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

    # Apply the default theme if not already set
    if [ ! -L ~/.config/theme ]; then
        omarchy-theme-set "osaka-jade"
    fi

    # Check if iwd is enabled
    if ! systemctl is-enabled iwd.service >/dev/null 2>&1; then
        echo -e "Enabling and starting iwd"
        sudo systemctl enable iwd.service --now
    fi

    # do not fail if hyprctl fails
    set +eE

    # Check if HYPRLAND_INSTANCE_SIGNATURE is set
    if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
        return
    fi

    hyprctl reload # Reload Hyprland to apply changes
}

function check() {
    if command -v hyprctl &>/dev/null; then
        show_success "Hyprland"
    else
        show_error "Hyprland" "Hyprland is not installed."
    fi

    if [ -d ~/.config/hypr ]; then
        show_success "Hyprland Configuration"
    else
        show_error "Hyprland Configuration" "Hyprland configuration is not set up."
    fi

    if command -v systemctl &> /dev/null; then
        if systemctl is-active --quiet iwd.service; then
            show_success "iwd Service"
        else
            show_error "iwd Service" "iwd service is not running."
        fi
    fi

    if [ -L ~/.config/theme ]; then
        show_success "Theme Symlink"
    else
        show_warning "Theme folder exists" "Your folder is not a symlink to a valid theme. You can run 'omarchy-theme-set <theme-name>' to change it."
    fi

    # Check if bin scripts are present in ~/.local/bin
    local missing_scripts=()
    for script in "$SCRIPT_DIR/bin/"*; do
        local script_name
        script_name=$(basename "$script")
        if [ ! -f "$HOME/.local/bin/$script_name" ]; then
            missing_scripts+=("$script_name")
        fi
    done

    if [ ${#missing_scripts[@]} -eq 0 ]; then
        show_success "Hyprland Bin Scripts"
    else
        local error_msg="The following scripts are missing in ~/.local/bin:"
        for script in "${missing_scripts[@]}"; do
            error_msg+="\n\t- $script"
        done
        show_error "Hyprland Bin Scripts" "$error_msg" 
    fi

    # Greetd check
    if command -v greetd &> /dev/null; then
        if systemctl is-active --quiet greetd.service; then
            show_success "greetd Service"
        else
            show_error "greetd Service" "greetd service is not running."
        fi
    else
        show_warning "greetd" "greetd is not installed. You can install it by running ./install/hyprland/greetd.sh"
    fi
}

# If exectued and not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup "$@"
fi