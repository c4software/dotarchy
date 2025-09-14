---
title: "Dotarchy Manual"
type: "landing"
---

Welcome to the Dotarchy manual. This documentation provides a guide to understanding, installing, and using the Dotarchy dotfiles.

![Screenshot](./screenshot.jpg)

- [Source code](https://github.com/c4software/dotarchy)

## Installation

To set up Dotarchy on your system, follow these steps:

1. **Clone the Repository**: Start by cloning the Dotarchy repository to your local machine using the following command:

   ```bash
   git clone https://github.com/c4software/dotarchy.git ~/dotarchy
   ```

2. **Run the Setup Script**: Navigate to the cloned directory and execute the setup script. This script will automatically detect your operating system and install the necessary packages and configurations.

   ```bash
   cd ~/dotarchy
   ./setup.sh
   ```

3. **Follow On-Screen Instructions**: The setup script may prompt you for additional input or confirmation during the installation process. Follow the on-screen instructions to complete the setup.

## Install only specific parts

If you want to install only specific parts of Dotarchy, such as the Hyprland setup on Arch Linux, you can navigate to the relevant directory and run the dedicated setup script. For example:

```bash
cd ~/dotarchy/
./install/hyprland/setup.sh
```

## Only update configuration files

To update only the configuration files without installing packages, you can run the Hyprland setup script with the `--skip-packages` flag:

```bash
./install/hyprland/setup.sh --skip-packages
```