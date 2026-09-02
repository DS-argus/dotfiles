#!/bin/bash
# Wi-Fi 연결 상태와 IP를 아이콘 및 저부하 팝업으로 표시한다.
source "$HOME/.config/sketchybar/colors.sh"

if [ "$SENDER" = "mouse.exited" ] || [ "$SENDER" = "mouse.exited.global" ]; then
  sketchybar --set "$NAME" popup.drawing=off
  exit 0
fi

IP="$(ipconfig getifaddr en0 2>/dev/null)"

if [ -n "$IP" ]; then
  sketchybar --set "$NAME" icon="󰖩" icon.color=$FROST2 \
             --set wifi.status icon="󰖩" icon.color=$FROST2 label="Wi-Fi · Connected" \
             --set wifi.ip label="IP · $IP"
else
  sketchybar --set "$NAME" icon="󰖪" icon.color=$MUTED \
             --set wifi.status icon="󰖪" icon.color=$MUTED label="Wi-Fi · Disconnected" \
             --set wifi.ip label="IP · None"
fi

if [ "$SENDER" = "mouse.entered" ]; then
  sketchybar --set battery popup.drawing=off \
             --set volume popup.drawing=off \
             --set bluetooth popup.drawing=off \
             --set dev_network popup.drawing=off \
             --set "$NAME" popup.drawing=on
fi
