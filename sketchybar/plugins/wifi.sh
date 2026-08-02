#!/bin/bash
# Wi-Fi 연결 상태 (SSID는 macOS 위치 권한 정책상 조회 불가 → 아이콘으로만 표시)
source "$HOME/.config/sketchybar/colors.sh"

if [ -n "$(ipconfig getifaddr en0 2>/dev/null)" ]; then
  sketchybar --set "$NAME" icon="󰖩" icon.color=$FROST2
else
  sketchybar --set "$NAME" icon="󰖪" icon.color=$MUTED
fi
