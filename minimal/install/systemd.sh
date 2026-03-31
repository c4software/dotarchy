function setup(){
    # Limit journal size to 50MB if not already set
    if ! grep -q "^SystemMaxUse=50M" /etc/systemd/journald.conf; then
        echo "SystemMaxUse=50M" | sudo tee -a /etc/systemd/journald.conf
    fi
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

    show_success "Systemd" "SystemMaxUse is set to 50M in /etc/systemd/journald.conf"
}