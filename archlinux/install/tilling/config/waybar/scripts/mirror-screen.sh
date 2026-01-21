#!/usr/bin/env bash

MIRROR_PROC="wl-mirror"
SIGNAL_WAYBAR="pkill -RTMIN+11 waybar"

get_outputs() { niri msg --json outputs 2>/dev/null | jq -r '.[] | .name' | sort -u; }

get_status() { pgrep -x "$MIRROR_PROC" >/dev/null && echo '{"text":" 󰄙 ","class":"on"}' || echo '{"text":" 󰞊 ","class":"off"}'; }

case "${1:-action}" in
indicator) get_status ;;
action)
  if pgrep -x "$MIRROR_PROC" >/dev/null; then
    pkill -x "$MIRROR_PROC"
    sleep 0.3
    # Disable do not disturb mode when stopping mirroring
    ~/.config/waybar/scripts/do-not-disturb.sh enable || true
  else
    o=$(get_outputs)
    [[ -z "$o" ]] && exit 1

    src=$(dotarchy-display-menu "Source" "$o" "" "" 380)
    [[ -z "$src" ]] && exit 0

    dst_list=$(echo "$o" | grep -v "^$src$")
    if [ $(echo "$dst_list" | wc -l) -eq 1 ] && [ -n "$dst_list" ]; then
      dst="$dst_list"
    else
      dst=$(dotarchy-display-menu "Destination" "$dst_list" "" "" 380)
      [[ -z "$dst" ]] && exit 0
    fi

    wl-mirror -F --show-cursor --fullscreen-output "$dst" "$src" &
    sleep 0.3

    # Enable do not disturb mode when mirroring only if wl-mirror started successfully
    pgrep -x "$MIRROR_PROC" >/dev/null && ~/.config/waybar/scripts/do-not-disturb.sh disable || true
  fi
  $SIGNAL_WAYBAR || true
  ;;
*)
  echo "Usage: $0 {indicator|action}" >&2
  exit 1
  ;;
esac
