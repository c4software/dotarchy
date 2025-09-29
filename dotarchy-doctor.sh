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