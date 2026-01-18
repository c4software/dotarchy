
function setup(){
    echo -e "Starting Bluetooth service..."
    sudo systemctl enable bluetooth.service
    sudo systemctl start bluetooth.service
}

function check(){
    # Check if systemctl command exists
    if ! command -v systemctl &> /dev/null; then
        show_warning "Bluetooth" "systemctl command not found."
        return
    fi

    if systemctl is-active --quiet bluetooth.service; then
        show_success "Bluetooth"
    else
        show_error "Bluetooth" "Bluetooth service is not running."
    fi
}