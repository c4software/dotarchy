function setup(){
    # Add the nuphy rules to /etc/udev/rules.d/99-nuphy.rules
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
}

function check(){
    # Check if the nuphy udev rules file exists
    if [ -f /etc/udev/rules.d/50-nuphy.rules ]; then
        show_success "NuPhy udev rules file exists"
    else
        show_error "NuPhy udev rules file" "The /etc/udev/rules.d/50-nuphy.rules file is missing."
    fi}