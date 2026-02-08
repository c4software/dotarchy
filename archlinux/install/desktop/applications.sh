# Install AppImage not available in the Arch repos

function setup(){
    mkdir -p "~/Applications"
    # Create quickcalc rofi entry
    # ~/.local/share/applications/quickcal.desktop
    cat <<EOF > ~/.local/share/applications/quickcal.desktop
[Desktop Entry]
Categories=Calculator;
Name=QuickCal
GenericName=Calculator
Exec=rofi -show calc -modi calc -no-show-match -no-sort -automatic-save-to-history
Icon=qalculate-qt
Type=Application
Keywords==;
EOF

}

function check() {
    # Check if quickcal desktop entry exists
    if [ -f "$HOME/.local/share/applications/quickcal.desktop" ]; then
        show_success "quickcal desktop entry"
    else
        show_error "quickcal desktop entry" "The quickcal desktop entry is missing in ~/.local/share/applications/."
    fi
}
