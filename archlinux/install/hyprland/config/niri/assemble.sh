#!/bin/bash

# Script to assemble Niri config from includes
# Since Niri doesn't support includes, this script concatenates the files

output_file="config.kdl"

# Start with header
cat > "$output_file" << 'EOF'
// This config is in the KDL format: https://kdl.dev
// "/-" comments out the following node.
// Check the wiki for a full description of the configuration:
// https://yalter.github.io/niri/Configuration:-Introduction

EOF

# Include files in order
cat includes/input.kdl >> "$output_file"
echo "" >> "$output_file"

cat includes/output.kdl >> "$output_file"
echo "" >> "$output_file"

cat includes/layout.kdl >> "$output_file"
echo "" >> "$output_file"

cat includes/autostart.kdl >> "$output_file"
echo "" >> "$output_file"

cat includes/hotkey-overlay.kdl >> "$output_file"
echo "" >> "$output_file"

# Add the global options
cat >> "$output_file" << 'EOF'
// Uncomment this line to ask the clients to omit their client-side decorations if possible.
// If the client will specifically ask for CSD, the request will be honored.
// Additionally, clients will be informed that they are tiled, removing some client-side rounded corners.
// This option will also fix border/focus ring drawing behind some semitransparent windows.
// After enabling or disabling this, you need to restart the apps for this to take effect.
// prefer-no-csd

// You can change the path where screenshots are saved.
// A ~ at the front will be expanded to the home directory.
// The path is formatted with strftime(3) to give you the screenshot date and time.
screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

// You can also set this to null to disable saving screenshots to disk.
// screenshot-path null

EOF

cat includes/workspaces.kdl >> "$output_file"
echo "" >> "$output_file"

cat includes/animations.kdl >> "$output_file"
echo "" >> "$output_file"

cat includes/window-rules.kdl >> "$output_file"
echo "" >> "$output_file"

cat includes/binds.kdl >> "$output_file"

echo "Config assembled into $output_file"