#!/usr/bin/env bash
# Docker rootless à côté du Docker root d'Omarchy.
#
#   docker …       → démon rootless de l'utilisateur (contexte « rootless »)
#   sudo docker …  → démon root (dev-box, VM Windows, TUI Omarchy)
#
# Utilise l'unité systemd du paquet AUR docker-rootless-extras plutôt que
# dockerd-rootless-setuptool.sh install (dont l'unité serait refusée par la
# future migration Omarchy #11386). Relançable sans risque : chaque étape
# vérifie d'abord si elle est déjà faite.

set -euo pipefail

ok()   { printf '\033[32m✓\033[0m %s\n' "$*"; }
info() { printf '\033[34m→\033[0m %s\n' "$*"; }
warn() { printf '\033[33m!\033[0m %s\n' "$*"; }
die()  { printf '\033[31m✗\033[0m %s\n' "$*" >&2; exit 1; }
confirm() {
  if command -v gum >/dev/null 2>&1; then gum confirm "$1"
  else read -rp "$1 [o/N] " r; [[ $r =~ ^[oOyY]$ ]]; fi
}

[[ $EUID -ne 0 ]] || die "à lancer avec ton utilisateur, pas en root (sudo est appelé quand il faut)"
: "${XDG_RUNTIME_DIR:=/run/user/$(id -u)}"
sock="$XDG_RUNTIME_DIR/docker.sock"

# 1. Prérequis ---------------------------------------------------------------
info "Prérequis"
grep -q "^$USER:" /etc/subuid && grep -q "^$USER:" /etc/subgid \
  || die "pas de plage pour $USER dans /etc/subuid ou /etc/subgid"
ok "subuid/subgid : $(grep "^$USER:" /etc/subuid)"

[[ $(sysctl -n kernel.unprivileged_userns_clone 2>/dev/null || echo 1) == 1 ]] \
  || die "kernel.unprivileged_userns_clone vaut 0"
ok "user namespaces non privilégiés autorisés"

# Socket root ouvert à tous (ex. chmod 666) : root sans mot de passe pour tout
# le monde, et le setuptool refuse de tourner. On le remet d'aplomb.
if [[ -S /var/run/docker.sock && -w /var/run/docker.sock ]]; then
  warn "/var/run/docker.sock est accessible en écriture ($(stat -c %a /var/run/docker.sock)) : équivalent root"
  if confirm "Recréer docker.socket (remet le socket en 660) ?"; then
    sudo systemctl restart docker.socket
    ok "socket root : $(stat -c '%a %U:%G' /var/run/docker.sock)"
  fi
else
  ok "socket root protégé"
fi

# Un contexte « rootless » qui vise autre chose (autre socket, hôte SSH) laisserait
# `docker` sur le mauvais démon : on refuse avant d'installer quoi que ce soit.
if docker context inspect rootless >/dev/null 2>&1; then
  context_host=$(docker context inspect rootless --format '{{.Endpoints.docker.Host}}')
  [[ $context_host == "unix://$sock" ]] \
    || die "le contexte docker « rootless » pointe vers $context_host : supprime-le (docker context rm rootless) puis relance"
  ok "contexte rootless existant sur $sock"
fi

# 2. Paquets -----------------------------------------------------------------
info "Paquets"
sudo pacman -S --needed rootlesskit slirp4netns
if pacman -Q docker-rootless-extras >/dev/null 2>&1; then
  ok "docker-rootless-extras déjà installé"
else
  command -v yay >/dev/null 2>&1 || die "yay introuvable (docker-rootless-extras est dans l'AUR)"
  info "docker-rootless-extras vient de l'AUR : relis le PKGBUILD quand yay le propose"
  yay -S --needed docker-rootless-extras
fi
[[ -f /usr/lib/systemd/user/docker.service ]] || die "unité utilisateur docker.service absente après installation"

# 3. Linger : le démon survit à la déconnexion et démarre au boot ------------
info "Linger"
if [[ $(loginctl show-user "$USER" -p Linger --value) == yes ]]; then
  ok "linger déjà actif"
else
  sudo loginctl enable-linger "$USER"
  ok "linger activé"
fi

# 4. Démon rootless ----------------------------------------------------------
info "Démon rootless"
[[ -f ~/.config/systemd/user/docker.service ]] \
  && warn "~/.config/systemd/user/docker.service existe (setuptool ?) et masque l'unité du paquet : supprime-le si ce n'est pas voulu"
systemctl --user daemon-reload
systemctl --user enable --now docker.service
for _ in $(seq 30); do [[ -S $sock ]] && break; sleep 0.5; done
[[ -S $sock ]] || die "le socket $sock n'est pas apparu : journalctl --user -u docker"
ok "démon rootless actif sur $sock"

# 5. Contexte ----------------------------------------------------------------
info "Contexte docker"
if docker context inspect rootless >/dev/null 2>&1; then
  ok "contexte rootless déjà présent"
else
  docker context create rootless --description "Docker rootless ($USER)" --docker "host=unix://$sock" >/dev/null
  ok "contexte rootless créé"
fi
docker context use rootless >/dev/null
[[ -z ${DOCKER_HOST:-} ]] || warn "DOCKER_HOST=$DOCKER_HOST est exporté et passe avant le contexte"
ok "contexte actif : $(docker context show)"

# 6. Vérifications -----------------------------------------------------------
info "Vérifications"
docker info --format '{{range .SecurityOptions}}{{.}} {{end}}' | grep -q rootless \
  || die "docker info ne signale pas rootless"
ok "docker info : rootless"
docker run --rm hello-world >/dev/null && ok "hello-world sans sudo"

if sudo env | grep -q '^DOCKER_'; then
  warn "sudo conserve des variables DOCKER_* : sudo docker risque de ne pas viser le démon root"
else
  ok "sudo docker → démon root ($(sudo docker context show 2>/dev/null || echo default))"
fi

cat <<EOF

Terminé.
  docker …        démon rootless (images : ~/.local/share/docker)
  sudo docker …   démon root (dev-box, VM Windows, api-capteurs…)
  Revenir au démon root par défaut : docker context use default
EOF
