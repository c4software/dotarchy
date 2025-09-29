function setup(){
    echo -e "Installing Printer Support"
    sudo systemctl enable --now cups.service

    # Disable multicast dns in resolved. Avahi will provide this for better network printer discovery
    sudo mkdir -p /etc/systemd/resolved.conf.d

    if [ ! -f /etc/systemd/resolved.conf.d/10-disable-multicast.conf ]; then
        echo -e "[Resolve]\nMulticastDNS=no" | sudo tee /etc/systemd/resolved.conf.d/10-disable-multicast.conf
    fi

    sudo systemctl enable --now avahi-daemon.service
}

function check(){
    # Check if systemctl command exists
    if ! command -v systemctl &> /dev/null; then
        show_warning "Printer Support" "systemctl command not found."
        return
    fi
    
    if ! systemctl is-active --quiet cups.service; then
        show_error "Printer Support" "CUPS service is not running."
        return
    fi

    if ! systemctl is-active --quiet avahi-daemon.service; then
        show_error "Printer Support" "Avahi service is not running."
        return
    fi

    local mdns_enabled
    mdns_enabled=$(grep -E '^\s*MulticastDNS\s*=\s*no' /etc/systemd/resolved.conf.d/10-disable-multicast.conf || true)

    if [ -z "$mdns_enabled" ]; then
        show_error "Printer Support" "MulticastDNS is not disabled in resolved."
        return
    fi

    show_success "Printer Support"
}