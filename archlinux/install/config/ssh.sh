function setup(){
    grep -qxF 'net.ipv4.tcp_mtu_probing=1' /etc/sysctl.d/99-sysctl.conf || echo 'net.ipv4.tcp_mtu_probing=1' | sudo tee -a /etc/sysctl.d/99-sysctl.conf
}

function check(){
    local mtu_probing
    if ! mtu_probing=$(sysctl net.ipv4.tcp_mtu_probing 2>/dev/null | awk '{print $3}'); then
        show_error "SSH" "Warning: Failed to retrieve TCP MTU probing status."
        mtu_probing=0
    fi

    if [ "$mtu_probing" == "1" ]; then
        show_success "SSH"
    else
        show_error "SSH" "TCP MTU probing is not enabled."
    fi
}