# Niri Configuration with Includes

This Niri configuration is structured similarly to Hyprland, with separate files for different sections.

Since Niri does not support includes natively, a script `assemble.sh` is used to concatenate the files into `config.kdl`.

## Structure

- `includes/input.kdl`: Input device configuration
- `includes/output.kdl`: Output (monitor) configuration
- `includes/layout.kdl`: Window layout settings
- `includes/autostart.kdl`: Startup processes
- `includes/hotkey-overlay.kdl`: Hotkey overlay settings
- `includes/workspaces.kdl`: Workspace definitions
- `includes/animations.kdl`: Animation settings
- `includes/window-rules.kdl`: Window rules
- `includes/binds.kdl`: Key bindings

## Usage

To modify the configuration, edit the files in `includes/` and run `./assemble.sh` to generate `config.kdl`.

## Comparison to Hyprland

This structure mirrors the Hyprland configuration in `../hypr/`, allowing for easier management and similarity between the two compositors.
