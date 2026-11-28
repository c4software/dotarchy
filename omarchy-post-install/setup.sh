#!/usr/bin/env bash
# Post-install Omarchy : lance les modules de modules/ dans l'ordre de leur numéro.
#
#   ./setup.sh                    tous les modules
#   ./setup.sh apps ai-agents     seulement ceux-là (nom sans numéro ni .sh)
#   ./setup.sh --list             liste les modules
#
# Un module peut aussi se lancer seul : ./modules/50-apps.sh
# Comme avant le découpage, une commande en échec n'arrête pas la suite.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SCRIPT_DIR

name_of() { local n=${1##*/}; n=${n%.sh}; echo "${n#[0-9]*-}"; }

modules=("$SCRIPT_DIR"/modules/[0-9]*.sh)

if [ "$1" = --list ]; then
  for m in "${modules[@]}"; do
    printf '%-12s %s\n' "$(name_of "$m")" "$(sed -n '2s/^# //p' "$m")"
  done
  exit 0
fi

selected=()
if [ $# -eq 0 ]; then
  selected=("${modules[@]}")
  export DOTARCHY_SETUP_ALL=1
else
  for want in "$@"; do
    found=
    for m in "${modules[@]}"; do
      [ "$(name_of "$m")" = "$want" ] && { selected+=("$m"); found=1; }
    done
    [ -n "$found" ] || { echo "Module inconnu : $want (./setup.sh --list)" >&2; exit 1; }
  done
fi

for m in "${selected[@]}"; do
  printf '\n\033[1;34m==> %s\033[0m\n' "$(name_of "$m")"
  bash "$m" || echo "⚠ module $(name_of "$m") : code de sortie $?" >&2
done
