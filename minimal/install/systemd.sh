function setup(){
    # Limit journal size to 50MB if not already set
    if ! grep -q "^SystemMaxUse=50M" /etc/systemd/journald.conf; then
        echo "SystemMaxUse=50M" | sudo tee -a /etc/systemd/journald.conf
    fi

    # Disable systemd-resolved
    sudo systemctl stop systemd-resolved.service
    sudo systemctl disable systemd-resolved.service
    sudo systemctl mask systemd-resolved.service

    # Remove resolv.conf and create NetworkManager conf directory
    sudo rm -f /etc/resolv.conf
    sudo mkdir -p /etc/NetworkManager/conf.d 

    # Disable systemd-resolved if it's running and set NetworkManager to use default DNS
    sudo tee /etc/NetworkManager/conf.d/no-resolved.conf > /dev/null << 'EOF'
[main]
dns=default
EOF

    sudo systemctl restart NetworkManager.service
}

function check(){
    # Chck if the /etc/systemd/journald.conf exists
    if [ ! -f /etc/systemd/journald.conf ]; then
        show_warning "Systemd" "/etc/systemd/journald.conf does not exist."
        return
    fi

    local journal_size
    journal_size=$(grep "^SystemMaxUse=" /etc/systemd/journald.conf | awk -F= '{print $2}' | tr -d '[:space:]')

    if [ "$journal_size" != "50M" ]; then
        show_error "Systemd" "SystemMaxUse is not set to 50M in /etc/systemd/journald.conf"
        return
    fi

    # Check if systemd-resolved is disabled
    if systemctl is-active --quiet systemd-resolved.service; then
        show_error "Systemd" "systemd-resolved.service is still active."
        return
    fi

    show_success "Systemd" "SystemMaxUse is set to 50M in /etc/systemd/journald.conf"
}