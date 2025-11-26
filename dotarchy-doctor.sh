#!/bin/bash

# Function used in scripts to show error messages
function show_error() {
    echo -e "\033[0;31m❌ $1\033[0m"
    if [ -n "$2" ]; then
        echo -e "\t\033[0;31m$2\033[0m"
        echo ""
    fi
}

# Function used in scripts to show success messages
function show_success() {
    echo -e "\033[0;32m✅ $1\033[0m"
}

# Function used in script to show warning messages
function show_warning() {
    echo -e "\033[0;33m⚠️  $1\033[0m"
    if [ -n "$2" ]; then
        echo -e "\t\033[0;33m$2\033[0m"
        echo ""
    fi
}

gum style --border double --align center --width 40 "Checking common configuration"
echo ""

# Check common configuration files
(
    source common/install/bootstrap.sh
    check
)

gum style --border double --align center --width 40 "Checking Arch Linux setup"
echo ""

# Check all Arch Linux configuration files
source ./archlinux/doctor.sh

# Ask to reinstall missing packages
if gum confirm "Do you want to reinstall missing packages?"; then
    echo ""
    gum style --border double --align center --width 40 "Updating package database"
    sudo pacman -Syu

    gum style --border double --align center --width 40 "Reinstalling missing packages"
    echo ""

    # Find for every packages.txt and packages.aur.txt files and reinstall missing packages. Confirm for each file.
    while IFS= read -r file; do
        dir=$(dirname "$file")

        if gum confirm "Reinstall packages from $file located in $dir?" < /dev/tty; then
            if [ "$(basename "$file")" = "packages.txt" ]; then
                echo "Reinstalling missing packages from $file with pacman"
                grep -Ev '^(#|$)' "$file" | sudo pacman -S --noconfirm --needed -
            else
                echo "Reinstalling missing packages from $file with yay"
                grep -Ev '^(#|$)' "$file" | yay -S --noconfirm --needed -
            fi
        fi
    done < <(find . -type f \( -name "packages.txt" -o -name "packages.aur.txt" \))

fi
