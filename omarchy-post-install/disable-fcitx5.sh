#!/usr/bin/env bash
# Désactive fcitx5 (méthode de saisie d'Omarchy).
#
# Quand la machine est chargée (compilations), toutes les frappes passant par
# fcitx5 (clavier virtuel Wayland) arrivent en retard et certaines touches se
# répètent. Sans fcitx5, Hyprland reçoit le clavier directement. Bépo et touches
# mortes viennent de xkb ; seul Super+I (changement de méthode) ne sert plus.
#
# - service utilisateur masqué : une mise à jour d'Omarchy ne le relance pas ;
# - variables IM vidées : environment.d de l'utilisateur prime sur
#   /usr/lib/environment.d/10-omarchy-fcitx.conf (effectif à la prochaine session).
#
# Réactiver :
#   systemctl --user unmask --now omarchy-fcitx5.service
#   rm ~/.config/environment.d/90-no-fcitx.conf

set -euo pipefail

systemctl --user mask --now omarchy-fcitx5.service

mkdir -p ~/.config/environment.d
cat >~/.config/environment.d/90-no-fcitx.conf <<'EOF'
# fcitx5 désactivé (service masqué) : lag et répétitions de touches sous charge.
# Écrase /usr/lib/environment.d/10-omarchy-fcitx.conf.
INPUT_METHOD=
QT_IM_MODULE=
XMODIFIERS=
SDL_IM_MODULE=
EOF

systemctl --user unset-environment INPUT_METHOD QT_IM_MODULE XMODIFIERS SDL_IM_MODULE
