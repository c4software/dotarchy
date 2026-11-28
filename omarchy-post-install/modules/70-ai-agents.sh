#!/usr/bin/env bash
# Agents IA : extensions et MCP llm-proxy pour pi, omp, Codex et opencode, clé de compte.
SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

# Les extensions llm-proxy.ts (pi / omp, opencode) vivent dans le dépôt du
# proxy, à côté de la page qui les affiche (Configuration → Clients) : prises
# sur sa branche master. Téléchargement impossible : le fichier en place est
# gardé.
LLM_PROXY_RAW=https://raw.githubusercontent.com/c4software/llm-proxy/master/proxy/llm_proxy/ui/web/static/config
llm_proxy_ext() { # <fichier du dépôt du proxy> <destination>
  if curl -fsSL "$LLM_PROXY_RAW/$1" -o "$2.tmp"; then
    mv -f "$2.tmp" "$2"
  else
    rm -f "$2.tmp"
    echo "⚠ $1 : téléchargement impossible, $2 inchangé" >&2
  fi
}

# Install pi / omp : provider llm-proxy (modèles du proxy) et serveur MCP du
# proxy (outils web : recherche, lecture de page et de PDF, recherche dans
# une page, mémoire…). Un mcp.json par agent : pi compte son `timeout` en
# secondes, omp en millisecondes. Un mcp.json déjà présent n'est pas écrasé.
for agent in pi omp; do
  dir=~/.$agent/agent
  mcp=mcp.json; [ $agent = omp ] && mcp=mcp.omp.json
  mkdir -p "$dir/extensions"
  llm_proxy_ext pi-llm-proxy.ts "$dir/extensions/llm-proxy.ts"
  [ -f "$dir/mcp.json" ] || cp "$SCRIPT_DIR/../common-no-omarchy/config/pi/$mcp" "$dir/mcp.json"
done

# Réglages omp (modèle par défaut, sous-agents) : config.omp.yml posé s'il
# manque ; omp écrit lui-même dans ce fichier, donc s'il existe seul le bloc
# `task` (sous-agents, clé de premier niveau) y est ajouté quand il manque.
omp_cfg="$SCRIPT_DIR/../common-no-omarchy/config/pi/config.omp.yml"
if [ ! -f ~/.omp/agent/config.yml ]; then
  cp "$omp_cfg" ~/.omp/agent/config.yml
elif ! grep -q '^task:' ~/.omp/agent/config.yml; then
  sed -n '/^task:/,$p' "$omp_cfg" >> ~/.omp/agent/config.yml
fi

# Codex : le provider llm-proxy et le même serveur MCP du proxy, ajoutés à
# ~/.codex/config.toml s'ils n'y sont pas — le fichier n'est pas remplacé,
# Codex y écrit lui-même (projets de confiance, interface). Sans provider
# choisi, `model_provider` et un modèle de départ sont posés en tête (clés de
# premier niveau : avant toute table), avec le catalogue des modèles du proxy
# (llm-proxy-models.json) : sans lui, Codex leur refuse tout niveau de
# raisonnement ; il remplace le catalogue intégré. Il se télécharge depuis la
# page du proxy (Configuration → Clients → Codex CLI, case « catalogue », les
# modèles voulus cochés), seule source : niveaux de chaque modèle déclarés
# par son backend (model_efforts), contexte, instructions de base. /model
# propose les autres modèles du catalogue. Sans raisonnement par défaut :
# -c model_reasoning_effort=low évite que Flash-Next recopie sans fin son
# dernier appel d'outil (gufo #388), mais coûte environ x3 en temps. Connecteurs ChatGPT coupés ([features] apps) :
# connecté à ChatGPT, Codex en ajoute 115 outils, et gufo refuse une requête
# de plus de 128.
mkdir -p ~/.codex
touch ~/.codex/config.toml
grep -q '^\[model_providers\.llm-proxy\]' ~/.codex/config.toml \
  || cat "$SCRIPT_DIR/../common-no-omarchy/config/codex/provider-llmproxy.toml" >> ~/.codex/config.toml
if ! grep -q '^model_provider *=' ~/.codex/config.toml; then
  printf '%s\n' 'model = "silentchuck/qwen3.8-flash-next"' 'model_provider = "llm-proxy"' \
    "model_catalog_json = \"$HOME/.codex/llm-proxy-models.json\"" \
    'model_reasoning_effort = "none"' '' | cat - ~/.codex/config.toml > ~/.codex/config.toml.new
  mv ~/.codex/config.toml.new ~/.codex/config.toml
fi
grep -q '^\[mcp_servers\.llmproxy\]' ~/.codex/config.toml \
  || cat "$SCRIPT_DIR/../common-no-omarchy/config/codex/mcp-llmproxy.toml" >> ~/.codex/config.toml
grep -q '^\[features\]' ~/.codex/config.toml \
  || printf '\n[features]\napps = false\n' >> ~/.codex/config.toml
[ -f ~/.codex/llm-proxy-models.json ] \
  || echo "Codex : télécharger le catalogue depuis la page du proxy (Configuration → Clients → Codex CLI) dans ~/.codex/llm-proxy-models.json."

# Clé de compte llm-proxy (~/.config/llm-proxy.key, lue par zsh/envs) : à
# poser maintenant ou plus tard avec llm-proxy-key.
if [ ! -s ~/.config/llm-proxy.key ] && gum confirm --default=false "Poser la clé de compte llm-proxy ?"; then
  ~/.local/bin/llm-proxy-key || true
fi

# opencode (2.x) : le plugin llm-proxy — provider `llmproxy` (modèles lus sur
# /v1/models du proxy) et serveur MCP du proxy, outils web intégrés retirés.
# Il vient du dépôt du proxy, comme llm-proxy.ts de pi et omp.
mkdir -p ~/.config/opencode/plugins
llm_proxy_ext opencode-llm-proxy.ts ~/.config/opencode/plugins/llm-proxy.ts
