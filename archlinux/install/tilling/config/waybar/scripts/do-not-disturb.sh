#!/usr/bin/env bash

SIGNAL_WAYBAR="pkill -RTMIN+9 waybar"

get_status() {
  current_mode=$(swaync-client --get-dnd)
  
  if [[ "$current_mode" == "true" ]]; then
    echo '{"text": "", "tooltip": "All notifications are silenced", "class": "active"}'
  else
    echo '{"text": "", "tooltip": "Notifications are enabled", "class": "inactive"}'
  fi
}

send_notification() {
  if [[ "$1" == "enable" ]]; then
    notify-send 'Notifications are now enabled.'
  else
    notify-send 'Notifications are now disabled.'
  fi
}

case "${1:-action}" in
indicator) get_status ;;
disable)
  swaync-client --dnd-off
  send_notification disable
  $SIGNAL_WAYBAR || true
  ;;
enable)
  swaync-client --dnd-on
  send_notification enable
  $SIGNAL_WAYBAR || true
  ;;
action)
  swaync-client --toggle-panel
  ;;
*)
  echo "Usage: $0 {indicator|action}" >&2
  exit 1
  ;;
esac