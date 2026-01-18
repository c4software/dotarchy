function setup(){
    # Create the plymouth.conf file to /etc/mkinitcpio.conf.d/plymouth.conf
    echo "Creating /etc/mkinitcpio.conf.d/plymouth.conf..."
    sudo tee /etc/mkinitcpio.conf.d/plymouth.conf >/dev/null <<'EOF'
HOOKS+=(plymouth)
EOF

    # Rebuild the initramfs
    echo "Rebuilding initramfs with plymouth hook..."
    sudo mkinitcpio -P

    # Add quiet, plymouth.nolog and splash to /boot/loader/entries/*.conf if not already present
    if [ -d "/boot/loader/entries" ]; then
        for entry in /boot/loader/entries/*.conf; do
            if ! grep -q "quiet" "$entry"; then
                echo "Adding quiet at the end of $entry..."
                sudo sed -i 's/^options /&quiet /' "$entry"
            fi
            if ! grep -q "splash" "$entry"; then
                echo "Adding splash at the end of $entry..."
                sudo sed -i 's/^options /&splash /' "$entry"
            fi

            if ! grep -q "plymouth.nolog" "$entry"; then
                echo "Adding plymouth.nolog at the end of $entry..."
                sudo sed -i 's/^options /&plymouth.nolog /' "$entry"
            fi
        done
    fi
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