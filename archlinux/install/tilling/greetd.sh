#!/bin/bash

# Check if greetd is already installed
if command -v greetd > /dev/null 2>&1; then
    echo "greetd is already installed."
    if ! gum confirm "Do you want to update greetd configuration?"; then
        return 0
    fi
else
    echo "greetd is not installed."
    if ! gum confirm "Do you want to install greetd and greetd-tuigreet?"; then
        return 0
    fi
fi

# Install only if not already installed
if ! command -v greetd > /dev/null 2>&1; then
    sudo pacman -S greetd greetd-tuigreet
fi

# Test if GDM is installed and disable it
if systemctl list-unit-files | grep -q gdm.service; then
    echo "Disabling GDM..."
    sudo systemctl disable gdm.service
fi

# Test if ssdm is installed and disable it
if systemctl list-unit-files | grep -q sddm.service; then
    echo "Disabling SDDM..."
    sudo systemctl disable sddm.service
fi

# Test if lightdm is installed and disable it
if systemctl list-unit-files | grep -q lightdm.service; then
    echo "Disabling LightDM..."
    sudo systemctl disable lightdm.service
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
command = "tuigreet --cmd 'niri-session'"
user = "greeter"

EOF

# Ask the user if he wants to enable autologin for his user
if gum confirm "Do you want to enable autologin for your user?"; then
    sudo tee -a /etc/greetd/config.toml > /dev/null <<EOF
[initial_session]
command = "niri-session"
user="$USER"

EOF
fi

echo "greetd and greetd-tuigreet installation and configuration completed."