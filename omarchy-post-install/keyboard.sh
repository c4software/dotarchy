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

    # Apple keyboard key swapping
    echo "Swapping left alt and left super keys..."
    echo "options hid_apple swap_opt_cmd=1 swap_fn_leftctrl=1" | sudo tee /etc/modprobe.d/hid_apple.conf
    mkinitcpio -P
}