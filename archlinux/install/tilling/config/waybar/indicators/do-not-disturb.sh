#!/bin/bash

current_mode=$(makoctl mode | grep "do-not-disturb")

if [[ "$current_mode" == "do-not-disturb" ]]; then
  echo '{"text": "", "tooltip": "All notifications are silenced", "class": "active"}'
else
  echo '{"text": "", "tooltip": "Notifications are enabled", "class": "inactive"}'
fi