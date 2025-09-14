---
title: "The User"
weight: 3
---

This section covers user-specific configurations.

- Shell environment (bash, zsh)
- Aliases and functions
- Input configuration

## Shell

The primary shell is configured through files in `common/config/bash`.

### Aliases

A number of aliases are defined in `common/config/bash/aliases` to simplify common commands. Some examples:

- `ls='eza -lh --group-directories-first --icons=auto'`: A modern `ls` replacement.
- `ff='nvim "$(fzf -m --preview "bat --style=numbers --color=always {}")"'`: Find and open files in Neovim with a fuzzy finder.
- `g='git'`: Shortcut for `git`.
- `d='docker'`: Shortcut for `docker`.
- `n`: A function to open Neovim, opening the current directory if no file is specified.

### TUI Shortcuts

A script `omarchy-tui-install` located in `common/bin` allows creating desktop shortcuts for terminal-based applications, making them launchable from the application menu.
