function setup(){
    if gum confirm "Do you want to enable clamshell mode (suspend on lid close if not docked)?"; then
        # If its a laptop (using presence of a battery)
        if [ -f /sys/class/power_supply/BAT0/uevent ]; then
            echo -e "Laptop detected"
            grep -qE '^\s*HandleLidSwitch\s*=' /etc/systemd/logind.conf || echo "HandleLidSwitch=suspend" | sudo tee -a /etc/systemd/logind.conf
            grep -qE '^\s*HandleLidSwitchDocked\s*=' /etc/systemd/logind.conf || echo "HandleLidSwitchDocked=ignore" | sudo tee -a /etc/systemd/logind.conf
        fi
    fi
}

function check(){
    # Check if systemctl command exists
    if ! command -v systemctl &> /dev/null; then
        show_warning "Clamshell mode" "systemctl command not found."
        return
    fi  

    if ! systemctl is-active --quiet systemd-logind; then
        show_error "Clamshell mode" "systemd-logind service is not running."
        return
    fi

    local handle_lid
    handle_lid=$(grep -E '^\s*HandleLidSwitch\s*=' /etc/systemd/logind.conf | awk -F= '{print $2}' | xargs)
    local handle_lid_docked
    handle_lid_docked=$(grep -E '^\s*HandleLidSwitchDocked\s*=' /etc/systemd/logind.conf | awk -F= '{print $2}' | xargs)

    if [ "$handle_lid" == "suspend" ] && [ "$handle_lid_docked" == "ignore" ]; then
        show_success "Clamshell mode"
    else
        show_error "Clamshell mode" "Lid switch settings are not correctly configured."
    fi
}