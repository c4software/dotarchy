# Create TUI Shortcut for LazyDocker, k9s

function setup(){
    omarchy-tui-install "Docker" "lazydocker" "tile" "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/docker.png"
    omarchy-tui-install "K9s" "k9s" "tile" "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/kubernetes-dashboard.png"
    omarchy-tui-install "Nvim" "nvim" "tile" "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/synology-text-editor.png"
}

function check() {
    # Check if TUI shortcuts exist ($HOME/.local/share/applications/*.desktop)
    local missing_shortcuts=()
    local tui_apps=("Docker" "K9s" "Nvim")
    for app in "${tui_apps[@]}"; do
        if [ ! -f "$HOME/.local/share/applications/$app.desktop" ]; then
            missing_shortcuts+=("$app")
        fi
    done

    if [ ${#missing_shortcuts[@]} -eq 0 ]; then
        show_success "TUI Shortcuts"
    else
        local error_msg="The following TUI shortcuts are missing in ~/.local/share/applications/:"
        for app in "${missing_shortcuts[@]}"; do
            error_msg+="\n\t- $app"
        done
        show_error "TUI Shortcuts" "$error_msg"
    fi
}
