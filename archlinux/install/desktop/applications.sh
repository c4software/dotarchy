# Install AppImage not available in the Arch repos

function setup(){
    mkdir -p ~/Applications
}

function check() {
    if [ ! -d ~/Applications ]; then
        show_error "Applications directory not found in home directory."
    else
        show_success "Applications directory"
    fi
}
