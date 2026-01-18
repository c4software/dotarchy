function setup(){
    # Create the plymouth.conf file to /etc/mkinitcpio.conf.d/plymouth.conf
    echo "Creating /etc/mkinitcpio.conf.d/plymouth.conf..."
    sudo tee /etc/mkinitcpio.conf.d/plymouth.conf >/dev/null <<'EOF'
HOOKS+=(plymouth)
EOF

    # Rebuild the initramfs
    echo "Rebuilding initramfs with plymouth hook..."
    sudo mkinitcpio -P
}

function check(){
    # Check if plymouth package is installed
    if pacman -Qi plymouth &> /dev/null; then
        show_success "Plymouth package is installed"
    else
        show_error "Plymouth package" "The plymouth package is not installed."
    fi

    # Check if plymouth hook is in the /etc/mkinitcpio.conf.d/plymouth.conf file
    if grep -q "HOOKS+=(plymouth)" /etc/mkinitcpio.conf.d/plymouth.conf; then
        show_success "Plymouth hook in mkinitcpio.conf.d/plymouth.conf"
    else
        show_error "Plymouth hook" "The plymouth hook is missing in /etc/mkinitcpio.conf.d/plymouth.conf."
    fi
}