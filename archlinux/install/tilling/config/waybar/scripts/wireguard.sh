#!/usr/bin/env bash

interfaces=$(ip -o link show type wireguard | awk -F': ' '{print $2}' | cut -d@ -f1)

if [ -z "$interfaces" ]; then
  echo '{"text":"󱙱 VPN","class":"disconnected","icon":""}'
else
  text=$(echo "${interfaces^}" | tr '\n' ' ' | sed 's/ $//')
  echo "{\"text\":\"󰌾 $text\",\"class\":\"connected\",\"icon\":\"\"}"
fi
