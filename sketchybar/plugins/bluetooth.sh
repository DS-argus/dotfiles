#!/bin/bash
# Bluetooth 전원/연결 상태를 아이콘 및 저부하 팝업으로 표시한다.
source "$HOME/.config/sketchybar/colors.sh"

if [ "$SENDER" = "mouse.exited" ] || [ "$SENDER" = "mouse.exited.global" ]; then
  sketchybar --set "$NAME" popup.drawing=off
  exit 0
fi

POWER="$(blueutil --power 2>/dev/null)"

if [ "$POWER" != "1" ]; then
  sketchybar --set "$NAME" icon="󰂲" icon.color=$MUTED \
             --set bluetooth.status icon="󰂲" icon.color=$MUTED label="Bluetooth · Off" \
             --set bluetooth.devices label="Devices · None"
else
  CONNECTED="$(blueutil --connected --format new-default 2>/dev/null)"
  SUMMARY="$(printf '%s\n' "$CONNECTED" | awk -F 'name: ' '
    NF > 1 {
      count++
      names = names (names ? ", " : "") $NF
    }
    END { printf "%d\t%s", count, names }
  ')"
  IFS=$'\t' read -r DEVICE_COUNT DEVICE_NAMES <<< "$SUMMARY"

  if [ "${DEVICE_COUNT:-0}" -gt 0 ]; then
    sketchybar --set "$NAME" icon="󰂱" icon.color=$FROST1 \
               --set bluetooth.status icon="󰂯" icon.color=$FROST3 label="Bluetooth · On" \
               --set bluetooth.devices label="Connected · $DEVICE_NAMES"
  else
    sketchybar --set "$NAME" icon="󰂯" icon.color=$FROST3 \
               --set bluetooth.status icon="󰂯" icon.color=$FROST3 label="Bluetooth · On" \
               --set bluetooth.devices label="Devices · None"
  fi
fi

if [ "$SENDER" = "mouse.entered" ]; then
  sketchybar --set battery popup.drawing=off \
             --set volume popup.drawing=off \
             --set wifi popup.drawing=off \
             --set dev_network popup.drawing=off \
             --set "$NAME" popup.drawing=on
fi
