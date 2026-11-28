#!/usr/bin/env bash
# Shell : zsh, ssh-agent, commandes de ~/.local/bin, tmux, Herdr.
SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
COMMON="$SCRIPT_DIR/../common-no-omarchy"

# Copy zsh configuration to the HOME config folder
cp -R "$COMMON/config/zsh/" ~/.config/
cp "$COMMON/default/zshrc" ~/.zshrc

# Install zsh and zsh-completions
sudo pacman -Sy --noconfirm zsh zsh-completions

# Force zsh startup (inspired by omarchy-zsh)
cp "$SCRIPT_DIR/configs/bashrc" ~/.bashrc

# ssh-agent : la config zsh (envs) pointe SSH_AUTH_SOCK sur $XDG_RUNTIME_DIR/ssh-agent.socket (sauf agent transmis en SSH),
# il faut donc activer l'unite socket d'OpenSSH (sinon aucun agent, et ForwardAgent est inutile)
systemctl --user enable --now ssh-agent.socket

mkdir -p ~/.local/bin

# Install try.sh command
curl -sL https://raw.githubusercontent.com/c4software/try.sh/main/try.sh -o ~/.local/bin/try
chmod +x ~/.local/bin/try

# Installation proj command
curl -sL https://raw.githubusercontent.com/c4software/prj.sh/main/prj.sh -o ~/.local/bin/proj
chmod +x ~/.local/bin/proj

# Cp the bin/* contents to ~/.local/bin/
cp "$SCRIPT_DIR"/bin/* ~/.local/bin/

# Herdr : Activate zsh in herdr configuration
[ -f ~/.config/herdr/config.toml ] && sed -i '/^\[terminal\]/a default_shell = "zsh"' ~/.config/herdr/config.toml

# Tmux : la config de dotarchy remplace celle d'Omarchy (zsh, Ctrl+T, boutons
# + et agents de la barre, barre latérale et palette des agents Herdr)
mkdir -p ~/.config/tmux
cp "$COMMON/config/tmux/tmux.conf" \
  "$COMMON/config/tmux/herdr.conf" \
  "$COMMON/config/tmux/herdr" ~/.config/tmux/
