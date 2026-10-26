#!/bin/bash

# Minisforum MS-S1 MAX : la carte Realtek RTL8127 (pilote r8169) se fige
# (« NETDEV WATCHDOG: transmit queue 0 timed out ») et perd des paquets.
# Corrigé le 11/10/2026 en coupant les offloads de la carte. L'EEE coupé seul
# ne suffisait pas, mais il est gardé coupé. Le réglage est enregistré dans les
# profils NetworkManager, il survit donc aux redémarrages.

# Ports Ethernet gérés par le pilote r8169 (les deux RJ45 de la machine)
IFACES=$(for dev in /sys/class/net/*; do
    [ "$(basename "$(readlink "$dev/device/driver" 2>/dev/null)")" = "r8169" ] && basename "$dev"
done)
if [ -z "$IFACES" ]; then
    echo "Aucune interface r8169 détectée"
    exit 1
fi
echo "Interfaces détectées : $(echo $IFACES)"

for IFACE in $IFACES; do
    # Profil NetworkManager lié à l'interface (actif ou non, port débranché compris)
    CONNECTION=$(nmcli -t -f NAME,TYPE con show | grep ":802-3-ethernet$" | cut -d: -f1 | while read -r name; do
        [ "$(nmcli -g connection.interface-name con show "$name")" = "$IFACE" ] && echo "$name"
    done | head -1)
    if [ -z "$CONNECTION" ]; then
        echo "Aucun profil NetworkManager lié à $IFACE, ignoré"
        continue
    fi

    echo "Coupure des offloads et de l'EEE sur « $CONNECTION » ($IFACE)..."
    sudo nmcli con mod "$CONNECTION" \
        ethtool.feature-tx off \
        ethtool.feature-rx off \
        ethtool.feature-gro off \
        ethtool.feature-tso off \
        ethtool.feature-gso off \
        ethtool.feature-sg off \
        ethtool.eee-enabled off

    # Wake-on-LAN par paquet magique (réveil depuis l'arrêt complet uniquement)
    echo "Activation du Wake-on-LAN..."
    sudo nmcli con mod "$CONNECTION" 802-3-ethernet.wake-on-lan magic

    # Application immédiate si le port est connecté (coupe le réseau quelques secondes),
    # sinon le réglage s'appliquera au branchement du câble
    if nmcli -t -f NAME con show --active | grep -qx "$CONNECTION"; then
        echo "Réapplication du profil..."
        sudo nmcli con up "$CONNECTION"
        ethtool -k "$IFACE" | grep -E "^(rx-checksumming|tx-checksumming|scatter-gather|tcp-segmentation-offload|generic-segmentation-offload|generic-receive-offload):"
    else
        echo "$IFACE non connecté, réglage appliqué au prochain branchement"
    fi
done
