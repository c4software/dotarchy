#!/usr/bin/env bash

SIGNAL_WAYBAR="pkill -RTMIN+9 waybar"

get_status() {
  current_mode=$(makoctl mode | grep "do-not-disturb")
  
  if [[ "$current_mode" == "do-not-disturb" ]]; then
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
  makoctl mode -a do-not-disturb
  send_notification disable
  $SIGNAL_WAYBAR || true
  ;;
enable)
  makoctl mode -r do-not-disturb
  send_notification enable
  $SIGNAL_WAYBAR || true
  ;;
action)
  current_mode=$(makoctl mode | grep "do-not-disturb")
  
  if [[ "$current_mode" == "do-not-disturb" ]]; then
    makoctl mode -t do-not-disturb
    send_notification enable
  else
    send_notification disable
    makoctl mode -t do-not-disturb
  fi
  
  $SIGNAL_WAYBAR || true
  ;;
*)
  echo "Usage: $0 {indicator|action}" >&2
  exit 1
  ;;
esac