# Install AppImage not available in the Arch repos

function setup(){
    mkdir -p "~/Applications"
    wget -O ~/Applications/OnlyOffice.AppImage "https://github.com/ONLYOFFICE/DesktopEditors/releases/latest/download/DesktopEditors-x86_64.AppImage"
    chmod +x ~/Applications/OnlyOffice.AppImage

    # Create desktop shortcut
    cat <<EOF > ~/.local/share/applications/OnlyOffice.desktop
[Desktop Entry]
Type=Application
Name=ONLYOFFICE Desktop Editors
GenericName=Office Suite
Comment=Edit office documents
Exec=/home/vbrosseau/Applications/OnlyOffice.AppImage %U
Icon=onlyoffice
Terminal=false
StartupWMClass=ONLYOFFICE
Categories=Office;WordProcessor;Spreadsheet;Presentation;
MimeType=application/msword;application/vnd.openxmlformats-officedocument.wordprocessingml.document;application/vnd.oasis.opendocument.text;application/vnd.ms-excel;application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;application/vnd.oasis.opendocument.spreadsheet;application/vnd.ms-powerpoint;application/vnd.openxmlformats-officedocument.presentationml.presentation;application/vnd.oasis.opendocument.presentation;
EOF

}

function check() {
    # Check if OnlyOffice AppImage exists
    if [ -f "$HOME/Applications/OnlyOffice.AppImage" ]; then
        show_success "OnlyOffice AppImage"
    else
        show_error "OnlyOffice AppImage" "The OnlyOffice AppImage is missing in ~/Applications/."
    fi
}
