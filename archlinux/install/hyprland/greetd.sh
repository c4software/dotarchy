#!/bin/bash

read -p "Do you want to install greetd and greetd-tuigreet? (y/n): " choice

if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    sudo pacman -S greetd greetd-tuigreet

    # Test if GDM is installed and disable it
    if systemctl list-unit-files | grep -q gdm.service; then
        echo "Disabling GDM..."
        sudo systemctl disable gdm.service
    fi

    echo "Enabling greetd..."
    sudo systemctl enable greetd.service
    
    sudo tee /etc/greetd/config.toml > /dev/null <<EOF
[terminal]
# The VT to run the greeter on. Can be "next", "current" or a number
# designating the VT.
vt = 1

# The default session, also known as the greeter.
[default_session]
command = "tuigreet --cmd 'uwsm start hyprland.desktop'"
user = "greeter"

EOF

    # Ask the user if he wants to enable autologin for his user
    read -p "Do you want to enable autologin for your user? (y/n): " autologin_choice
    if [ "$autologin_choice" = "y" ] || [ "$autologin_choice" = "Y" ]; then
        sudo tee -a /etc/greetd/config.toml > /dev/null <<EOF
[initial_session]
command = "uwsm start hyprland.desktop"
user="$USER"

EOF
    fi

    echo "greetd and greetd-tuigreet installation and configuration completed."
fi