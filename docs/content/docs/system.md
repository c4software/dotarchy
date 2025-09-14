---
title: "The System"
weight: 2
---

This section describes the system-level configurations and installations.

It includes:

- Base system setup
- Package management
- System services

## Packages

The system installs a set of essential packages for a functional environment. These are defined in `archlinux/install/system/packages.txt`.

Key packages include:

- **`fuse`**: For AppImage support.
- **`bluez`**, **`bluez-utils`**: Bluetooth support.
- **`fwupd`**: For firmware updates.
- **`power-profiles-daemon`**: For managing power profiles.
- **`cups`**: For printing support.
- **`ufw`**: A simple firewall.
- **`bolt`**: For Thunderbolt device management.
