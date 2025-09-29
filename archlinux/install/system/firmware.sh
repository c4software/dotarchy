function setup(){
    if lscpu | grep -q "Intel"; then
        sudo pacman -S --noconfirm --needed intel-ucode
    elif lscpu | grep -q "AMD"; then
        sudo pacman -S --noconfirm --needed amd-ucode
    fi
}

function check(){
    
    # Test if lscpu command exists
    if ! command -v lscpu &> /dev/null; then
        show_error "Firmware" "lscpu command not found."
        return
    fi

    if lscpu | grep -q "Intel"; then
        if pacman -Qi intel-ucode &> /dev/null; then
            show_success "Firmware"
        else
            show_error "Firmware" "intel-ucode is not installed."
        fi
    elif lscpu | grep -q "AMD"; then
        if pacman -Qi amd-ucode &> /dev/null; then
            show_success "Firmware"
        else
            show_error "Firmware" "amd-ucode is not installed."
        fi
    else
        show_success "Firmware" "No Intel or AMD CPU detected, no microcode needed."
    fi
}