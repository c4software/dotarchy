function setup(){
    # Limit journal size to 50MB if not already set
    if ! grep -q "^SystemMaxUse=50M" /etc/systemd/journald.conf; then
        echo "SystemMaxUse=50M" | sudo tee -a /etc/systemd/journald.conf
    fi

    # Prevent systemd-networkd-wait-online timeout on boot
    sudo systemctl disable systemd-networkd-wait-online.service
    sudo systemctl mask systemd-networkd-wait-online.service

    # Create a file with DNS settings for wg interfaces (/etc/systemd/network/50-wg-all.network)
    local wg_config_file="/etc/systemd/network/50-wg-all.network"
    
    if [ ! -f "$wg_config_file" ]; then
        echo "Creating WireGuard DNS priority configuration..."
        sudo mkdir -p /etc/systemd/network
        
        sudo tee "$wg_config_file" > /dev/null << 'EOF'
[Match]
Name=wg*

[Network]
Domains=~.
DNSDefaultRoute=yes
EOF
    fi

    # Remplacer /etc/resolv.conf par un lien symbolique vers le stub de systemd-resolved
    # Cela garantit que les résolutions DNS passent par systemd-resolved.
    sudo rm /etc/resolv.conf
    sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

    sudo systemctl enable --now systemd-resolved.service
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

    if systemctl is-enabled --quiet systemd-networkd-wait-online.service; then
        show_error "Systemd" "systemd-networkd-wait-online.service is enabled"
        return
    fi

    if [ ! -f "/etc/systemd/network/50-wg-all.network" ]; then
        show_error "Systemd" "/etc/systemd/network/50-wg-all.network does not exist."
        return
    fi

    # Check if systemd-resolved.service is enabled
    if ! systemctl is-enabled --quiet systemd-resolved.service; then
        show_error "Systemd" "systemd-resolved.service is not enabled"
        return
    fi

    # Check if /etc/resolv.conf is a symlink to /run/systemd/resolve/stub-resolv.conf
    if [ ! -L /etc/resolv.conf ] || [ "$(readlink /etc/resolv.conf)" != "/run/systemd/resolve/stub-resolv.conf" ]; then
        show_error "Systemd" "/etc/resolv.conf is not a symlink to /run/systemd/resolve/stub-resolv.conf"
        return
    fi

    show_success "Systemd and systemd-resolved are properly configured."
}