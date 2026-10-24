#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo pacman -Sy --noconfirm wget

# Copy zsh configuration to the HOME config folder
cp -R $SCRIPT_DIR/../common-no-omarchy/config/zsh/ ~/.config/
cp $SCRIPT_DIR/../common-no-omarchy/default/zshrc ~/.zshrc

# Install zsh and zsh-completions
sudo pacman -Sy --noconfirm zsh zsh-completions

# Force zsh startup (inspired by omarchy-zsh)
cp $SCRIPT_DIR/configs/bashrc ~/.bashrc

# ssh-agent : la config zsh (envs) pointe SSH_AUTH_SOCK sur $XDG_RUNTIME_DIR/ssh-agent.socket,
# il faut donc activer l'unite socket d'OpenSSH (sinon aucun agent, et ForwardAgent est inutile)
systemctl --user enable --now ssh-agent.socket

# Install try.sh command
curl -sL https://raw.githubusercontent.com/c4software/try.sh/main/try.sh -o ~/.local/bin/try
chmod +x ~/.local/bin/try

# Installation proj command
curl -sL https://raw.githubusercontent.com/c4software/prj.sh/main/prj.sh -o ~/.local/bin/proj
chmod +x ~/.local/bin/proj

# Copy the « Mix Light / Dark » theme to the Omarych Theme folder
cp -R $SCRIPT_DIR/../archlinux/install/tilling/config/themes/mix-light-dark ~/.config/omarchy/themes

# Installation bepoDev pour l'utilisateur
echo "Installing Bépo Dev keyboard layout (Utilisateur)..."
mkdir -p ~/.config/xkb/symbols ~/.config/xkb/rules || true
wget https://raw.githubusercontent.com/c4software/bepo_developpeur/master/linux/bepoDev -O ~/.config/xkb/symbols/bepoDev || true
wget https://raw.githubusercontent.com/c4software/bepo_developpeur/master/linux/evdev.lst -O ~/.config/xkb/rules/evdev.lst || true
wget https://raw.githubusercontent.com/c4software/bepo_developpeur/master/linux/evdev.xml -O ~/.config/xkb/rules/evdev.xml || true
[ -L ~/.config/xkb/rules/base.lst ] || ln -s ~/.config/xkb/rules/evdev.lst ~/.config/xkb/rules/base.lst || true
[ -L ~/.config/xkb/rules/base.xml ] || ln -s ~/.config/xkb/rules/evdev.xml ~/.config/xkb/rules/base.xml || true

echo -e "\nConfiguring uhid module to fix BLE mouse issue..."
echo -e "# Fix BLE mouse issue\nuhid" | sudo tee /etc/modules-load.d/uhid.conf

# Installation plugin alt-tab
omarchy plugin add https://github.com/c4software/hyprland-alttab --enable

# Cp the bin/* contents to ~/.local/bin/
cp $SCRIPT_DIR/bin/* ~/.local/bin/

# Create a vim alias
sudo ln -s /usr/bin/nvim /usr/bin/vim

# Move default configuration for hyprland
echo "Move default configuration for Hyprland"
cp $SCRIPT_DIR/configs/hypr/* ~/.config/hypr/

# Require customisation.lua from hyprland.lua if not already present
grep -q '^require("hypr.customisation")' ~/.config/hypr/hyprland.lua || echo 'require("hypr.customisation")' >>~/.config/hypr/hyprland.lua

# Idle : screensaver après 4h, lock après 6h (remplace l'ancien hypridle.conf)
jq '.idle.screensaver = 14400 | .idle.lock = 21600' ~/.config/omarchy/shell.json >~/.config/omarchy/shell.json.tmp && mv ~/.config/omarchy/shell.json.tmp ~/.config/omarchy/shell.json

# Sur secteur, capot fermé ne suspend plus (réveil à distance possible)
sudo cp "$SCRIPT_DIR/configs/logind-lid-remote-wake.conf" /etc/systemd/logind.conf.d/30-lid-remote-wake.conf
sudo systemctl kill -s HUP systemd-logind

# Uninstall some extra default application
sudo pacman -Rsnc 1password-beta 1password-cli chromium --noconfirm || true

# Installation de hunspell-fr
sudo pacman -Sy hunspell-fr --noconfirm

# Changement taille font dans Alacritty & Foot
sed -i 's/^size = 9$/size = 10/' ~/.config/alacritty/alacritty.toml
sed -i 's/^size=9$/size=10/' ~/.config/foot/foot.ini

# Enable autologin
sudo cp "$SCRIPT_DIR/configs/sddm-autologin.conf" /etc/sddm.conf.d/autologin.conf
sudo sed -i "s/USERNAME$/$USER/" /etc/sddm.conf.d/autologin.conf

# Install nvim configuration
cp "$SCRIPT_DIR/../common-no-omarchy/config/nvim/config/keymaps.lua" ~/.config/nvim/lua/config/keymaps.lua

# Install pi / omp : provider llm-proxy (modèles du proxy) et serveur MCP du
# proxy (outils web : recherche, lecture de page et de PDF, recherche dans
# une page, mémoire…). Un mcp.json par agent : pi compte son `timeout` en
# secondes, omp en millisecondes. Un mcp.json déjà présent n'est pas écrasé.
for agent in pi omp; do
  dir=~/.$agent/agent
  mcp=mcp.json; [ $agent = omp ] && mcp=mcp.omp.json
  mkdir -p "$dir/extensions"
  cp "$SCRIPT_DIR/../common-no-omarchy/config/pi/llm-proxy.ts" "$dir/extensions/"
  [ -f "$dir/mcp.json" ] || cp "$SCRIPT_DIR/../common-no-omarchy/config/pi/$mcp" "$dir/mcp.json"
done

# Codex : le provider llm-proxy et le même serveur MCP du proxy, ajoutés à
# ~/.codex/config.toml s'ils n'y sont pas — le fichier n'est pas remplacé,
# Codex y écrit lui-même (projets de confiance, interface). Sans provider
# choisi, `model_provider` et un modèle sont posés en tête (clés de premier
# niveau : avant toute table). Contexte : celui du catalogue du proxy
# (max_context_length), que Codex ne connaît pas. Avec eux, le catalogue des
# modèles du proxy (catalogue-local.json, suit le dépôt) : sans lui, Codex
# leur refuse tout niveau de raisonnement ; il remplace le catalogue intégré
# (instructions de base de Codex 0.164.0). Sans raisonnement par défaut :
# -c model_reasoning_effort=low évite que Flash-Next recopie sans fin son
# dernier appel d'outil (gufo #388), mais coûte environ x3 en temps.
mkdir -p ~/.codex
cp "$SCRIPT_DIR/../common-no-omarchy/config/codex/catalogue-local.json" ~/.codex/
touch ~/.codex/config.toml
grep -q '^\[model_providers\.llm-proxy\]' ~/.codex/config.toml \
  || cat "$SCRIPT_DIR/../common-no-omarchy/config/codex/provider-llmproxy.toml" >> ~/.codex/config.toml
if ! grep -q '^model_provider *=' ~/.codex/config.toml; then
  printf '%s\n' 'model = "silentchuck/qwen3.8-flash-next"' 'model_context_window = 262144' \
    'model_provider = "llm-proxy"' "model_catalog_json = \"$HOME/.codex/catalogue-local.json\"" \
    'model_reasoning_effort = "none"' '' | cat - ~/.codex/config.toml > ~/.codex/config.toml.new
  mv ~/.codex/config.toml.new ~/.codex/config.toml
fi
grep -q '^\[mcp_servers\.llmproxy\]' ~/.codex/config.toml \
  || cat "$SCRIPT_DIR/../common-no-omarchy/config/codex/mcp-llmproxy.toml" >> ~/.codex/config.toml

# Clé de compte llm-proxy (~/.config/llm-proxy.key, lue par zsh/envs) : à
# poser maintenant ou plus tard avec llm-proxy-key.
if [ ! -s ~/.config/llm-proxy.key ] && gum confirm --default=false "Poser la clé de compte llm-proxy ?"; then
  ~/.local/bin/llm-proxy-key || true
fi

# opencode (2.x) : le plugin llm-proxy — provider `llmproxy` (modèles lus sur
# /v1/models du proxy) et serveur MCP du proxy, outils web intégrés retirés.
# Il suit le dépôt, comme llm-proxy.ts de pi et omp.
mkdir -p ~/.config/opencode/plugins
cp "$SCRIPT_DIR/../common-no-omarchy/config/opencode/plugins/llm-proxy.ts" ~/.config/opencode/plugins/

# Herdr : Activate zsh in herdr configuration
[ -f ~/.config/herdr/config.toml ] && sed -i '/^\[terminal\]/a default_shell = "zsh"' ~/.config/herdr/config.toml

# Tmux Enable ZSH
echo 'set-option -g default-shell /bin/zsh' >>~/.config/tmux/tmux.conf

# Enable some keyboard stuff (nuphy, apple keyboard key swapping)
(
  source "$SCRIPT_DIR/keyboard.sh"
  setup
)

# Docker rootless (à la demande) : docker sans sudo, à côté du démon root d'Omarchy
if gum confirm --default=false "Installer Docker rootless (docker sans sudo) ?"; then
  "$SCRIPT_DIR/docker-rootless.sh"
fi
