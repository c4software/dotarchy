#!/usr/bin/env bash

MIRROR_CMD="wl-mirror --show-cursor --fullscreen-output DP-2 eDP-1"
PROCESS_NAME="wl-mirror"
SIGNAL_NUMBER=11
SIGNAL_CMD="pkill -RTMIN+$SIGNAL_NUMBER waybar"

MODE="${1:-action}"

get_status() {
  if pgrep -x "$PROCESS_NAME" >/dev/null; then
    echo "{\"text\": \" 󰄙 \", \"class\": \"on\", \"tooltip\": \"wl-mirror running on DP-2\"}"
  else
    echo "{\"text\": \" 󰞊 \", \"class\": \"off\", \"tooltip\": \"wl-mirror stopped\"}"
  fi
}

case "$MODE" in
indicator)
  get_status
  ;;
action)
  if pgrep -x "$PROCESS_NAME" >/dev/null; then
    pkill -x "$PROCESS_NAME"
  else
    $MIRROR_CMD &
  fi
  get_status
  $SIGNAL_CMD || true
  ;;
*)
  echo "Usage: $0 {indicator|action}" >&2
  exit 1
  ;;
esac
