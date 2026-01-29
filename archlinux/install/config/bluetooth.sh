
function setup(){
    echo -e "Starting Bluetooth service..."
    sudo systemctl enable bluetooth.service
    sudo systemctl start bluetooth.service

    echo -e "\nConfiguring uhid module to fix BLE mouse issue..."
    echo -e  "# Fix BLE mouse issue\nuhid" | sudo tee /etc/modules-load.d/uhid.conf
}

function check(){
    # Check if systemctl command exists
    if ! command -v systemctl &> /dev/null; then
        show_warning "Bluetooth" "systemctl command not found."
        return
    fi

    # Check if uhid module is loaded
    if lsmod | grep -q "^uhid"; then
        show_success "uhid module"
    else
        show_error "uhid module" "uhid module is not loaded."
    fi

    if systemctl is-active --quiet bluetooth.service; then
        show_success "Bluetooth"
    else
        show_error "Bluetooth" "Bluetooth service is not running."
    fi
}