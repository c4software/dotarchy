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

### Keybindings

Keybindings are defined in the `bindings.conf` file. This file includes shortcuts for launching applications, managing windows, and controlling system functions. The configuration uses a combination of modifier keys (like `SUPER`, `ALT`, and `CTRL`) and other keys to create a comprehensive set of shortcuts.

For a complete list of keybindings and their functions, refer to the [official Hyprland documentation on keybindings](https://wiki.hyprland.org/Configuring/Keybindings/).

There is some example content in the `bindings.conf` file:

```ini
# Launch terminal
bind = SUPER,RETURN,exec,uwsm app -- alacritty

# Close focused window
bind = SUPER,Q,close

# Switch to workspace 1
bind = SUPER,1,workspace,1

# Move focused window to workspace 2
bind = SUPER,SHIFT,2,movetoworkspace,2

# Toggle floating mode for focused window
bind = SUPER,F,modetoggle,floating
```

### Autostart

The `autostart.conf` file is used to launch applications and scripts automatically when Hyprland starts. This is useful for starting essential services like the notification daemon, the status bar, or the wallpaper manager.

For more details, you can refer to the [official documentation on executing applications](https://wiki.hyprland.org/Configuring/Executing/).

Here is an example from the configuration:

```ini
# Start the notification daemon
exec-once = uwsm app -- mako

# Start the status bar
exec-once = uwsm app -- waybar

# Set a random background
exec-once = uwsm app -- random-bg
```

### Environment Variables

The `envs.conf` file allows you to set environment variables that will be available within the Hyprland session. This is useful for configuring applications that rely on environment variables for their behavior.

For more information, see the [official documentation on environment variables](https://wiki.hyprland.org/Configuring/Variables/#environment-variables).

Example:

```ini
# Set cursor size
env = XCURSOR_SIZE,24
env = HYPRCURSOR_SIZE,24
```

### Input Devices

The `input.conf` file is where you configure your input devices, such as keyboards, mice, and touchpads. You can set options like keyboard layout, mouse sensitivity, and touchpad gestures.

Consult the [official documentation on input configuration](https://wiki.hyprland.org/Configuring/Variables/#input) for a complete list of options.

### Monitors

The `monitors.conf` file is used to define the layout, resolution, and refresh rate of your monitors. This is essential for multi-monitor setups.

For detailed configuration options, visit the [official documentation on configuring monitors](https://wiki.hyprland.org/Configuring/Monitors/).

Or use the `omarchy-monitor-resolution-picker` or `hyprmon` tools to help set up your monitors. Both are accessible via `Super + Space`.