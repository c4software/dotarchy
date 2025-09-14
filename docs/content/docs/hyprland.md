---
title: "Hyprland"
weight: 6
---

## Hyprland Configuration

Hyprland is a dynamic tiling Wayland compositor based on wlroots that doesn't sacrifice on its looks. The configuration for Hyprland is located in `archlinux/install/hyprland/config/hypr`.

### Structure

The configuration is split into multiple files for better organization:

- **`hyprland.conf`**: The main configuration file that sources all other configuration files.
- **`autostart.conf`**: Manages applications and scripts that are launched at startup.
- **`bindings.conf`**: Defines all keybindings and mouse bindings for window management, application launching, and system controls.
- **`envs.conf`**: Sets environment variables used by Hyprland and other applications.
- **`input.conf`**: Configures input devices such as keyboards, mice, and touchpads.
- **`monitors.conf`**: Defines monitor layouts, resolutions, and refresh rates.
- **`base/`**: This directory contains the core configuration files for different aspects of the compositor:
  - `apps.conf`: Window rules for specific applications.
  - `autostart.conf`: Core startup applications.
  - `bindings.conf`: Base keybindings.
  - `envs.conf`: Essential environment variables.
  - `hyprlock.conf`: Configuration for the screen locker.
  - `input.conf`: General input settings.
  - `looknfeel.conf`: Visual settings like gaps, borders, and animations.
  - `sidepad.conf`: Configuration for side panels or special devices.
  - `windows.conf`: General window management rules.

### Themes

The look and feel of Hyprland, including colors and styles for other applications like Waybar and Alacritty, are managed through themes located in `archlinux/install/hyprland/config/themes`. Each theme has its own directory containing specific configuration files.

### Scripts

A collection of useful scripts is available in `archlinux/install/hyprland/bin`. These scripts handle tasks like taking screenshots, managing power profiles, launching menus, and controlling system settings.
