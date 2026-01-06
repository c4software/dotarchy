function setup() {
    echo "Installing and enabling powertop service..."

    sudo tee /etc/systemd/system/powertop.service >/dev/null <<'EOF'
[Unit]
Description=Powertop tunings

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/powertop --auto-tune

[Install]
WantedBy=multi-user.target sleep.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable --now powertop.service

    if grep -q "AMD Ryzen AI 9 HX 370" /proc/cpuinfo; then
        echo
        echo "Ryzen AI 9 HX 370 detected! Remember to add:"
        echo "amd_pstate=active pcie_aspm=force"
        echo "to your kernel parameters (bootloader)"
    fi
}

function check() {
    if systemctl is-active --quiet powertop.service 2>/dev/null; then
        echo "Powertop service: active"
    else
        echo "Powertop service: inactive or non-existent"
    fi
    
    if grep -q "AMD Ryzen AI 9 HX 370" /proc/cpuinfo; then
        echo "Processor: AMD Ryzen AI 9 HX 370 detected"
    fi
}