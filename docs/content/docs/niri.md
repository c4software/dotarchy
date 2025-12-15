---
title: "Niri"
weight: 6
---

## Niri Configuration

Niri is a scrollable-tiling Wayland compositor with a unique column-based window model. The configuration for Niri is located in `archlinux/install/tilling/config/niri`.

### Structure

The configuration is split into multiple files for better organization:

- **`config.kdl`**: The main configuration file that sources all other configuration files.
- **`autostart.kdl`**: Manages applications and scripts that are launched at startup.
- **`binds.kdl`**: Defines all keybindings for window management, application launching, and system controls.
- **`environment.kdl`**: Sets environment variables used by Niri and other applications.
- **`input.kdl`**: Configures input devices such as keyboards, mice, and touchpads.
- **`output.kdl`**: Defines monitor layouts, resolutions, and refresh rates.
- **`layout.kdl`**: Visual settings like gaps, borders, and animations.
- **`window-rules.kdl`**: Window rules for specific applications.

### Themes

The look and feel of Niri, including colors and styles for other applications like Waybar and Alacritty, are managed through themes located in `archlinux/install/tilling/config/themes`. Each theme has its own directory containing specific configuration files.

### Scripts

A collection of useful scripts is available in `archlinux/install/tilling/bin`. These scripts handle tasks like taking screenshots, managing power profiles, launching menus, and controlling system settings.

### Global menu

You can trigger the global menu with `SUPER + Space`. This menu allows you to quickly access applications, settings, and other functionalities. In this menu, if the entry doesn't match any application or setting, it will perform a web search using your default browser.

### Keybindings

Keybindings are defined in the `binds.kdl` file. This file includes shortcuts for launching applications, managing windows, and controlling system functions. The configuration uses a combination of modifier keys (like `Mod`, `Alt`, and `Ctrl`) and other keys to create a comprehensive set of shortcuts.

For a complete list of keybindings and their functions, refer to the [official Niri documentation](https://github.com/YaLTeR/niri/wiki/Configuration:-Key-Bindings).

There is some example content in the `binds.kdl` file:

```kdl
// Launch terminal
Mod+Return { spawn "alacritty"; }

// Close focused window
Mod+W { close-window; }

// Switch to workspace 1
Mod+1 { focus-workspace 1; }

// Move focused window to workspace 2
Mod+Shift+2 { move-column-to-workspace 2; }
```

### Autostart

The `autostart.kdl` file is used to launch applications and scripts automatically when Niri starts. This is useful for starting essential services like the notification daemon, the status bar, or the wallpaper manager.

Here is an example from the configuration:

```kdl
// Start the notification daemon
spawn-at-startup "mako"

// Start the status bar
spawn-sh-at-startup "waybar --config ~/.config/waybar/niri.jsonc"

// Set a random background
spawn-at-startup "dotarchy-background" "set"
```

### Environment Variables

The `environment.kdl` file allows you to set environment variables that will be available within the Niri session. This is useful for configuring applications that rely on environment variables for their behavior.

Example:

```kdl
environment {
    XCURSOR_SIZE "24"
    HYPRCURSOR_SIZE "24"
}
```

### Input Devices

The `input.kdl` file is where you configure your input devices, such as keyboards, mice, and touchpads. You can set options like keyboard layout, mouse sensitivity, and touchpad gestures.

### Monitors

The `output.kdl` file is used to define the layout, resolution, and refresh rate of your monitors. This is essential for multi-monitor setups.

You can edit this file via `Super + Space` > Setup > Monitors.
