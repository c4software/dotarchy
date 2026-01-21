#!/usr/bin/env bash

MIRROR_PROCESS="wl-mirror"
WAYBAR_SIGNAL_CMD="pkill -RTMIN+11 waybar"

get_outputs() {
  niri msg --json outputs 2>/dev/null |
    jq -r '.[] | .name' 2>/dev/null |
    sort -u
}

get_status() {
  pgrep -x "$MIRROR_PROCESS" >/dev/null &&
    echo '{"text":" 󰄙 ","class":"on","tooltip":"wl-mirror actif"}' ||
    echo '{"text":" 󰞊 ","class":"off","tooltip":"wl-mirror arrêté"}'
}

case "${1:-action}" in
indicator)
  get_status
  ;;

action)
  if pgrep -x "$MIRROR_PROCESS" >/dev/null; then
    pkill -x "$MIRROR_PROCESS"
  else
    outputs=$(get_outputs)
    [[ -z "$outputs" ]] && {
      notify-send "Erreur" "Aucune sortie détectée via niri msg outputs"
      exit 1
    }

    source_output=$(dotarchy-display-menu "Source (à refléter)" "$outputs" "" "" 380)
    [[ -z "$source_output" ]] && exit 0

    dest_output=$(dotarchy-display-menu "Destination (affichage)" "$outputs" "" "" 380)
    [[ -z "$dest_output" ]] && exit 0

    wl-mirror -F --show-cursor --fullscreen-output "$dest_output" "$source_output" &
    sleep 0.3
  fi

  get_status
  $WAYBAR_SIGNAL_CMD || true
  ;;

*)
  echo "Usage: $0 {indicator|action}" >&2
  exit 1
  ;;
esac
