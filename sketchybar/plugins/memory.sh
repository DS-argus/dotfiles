#!/bin/bash
# macOS memory pressure 기반 가용량을 사용률 형태로 표시
source "$HOME/.config/sketchybar/colors.sh"

FREE="$(memory_pressure -Q 2>/dev/null | awk '/System-wide memory free percentage:/ { gsub(/%/, "", $5); print $5 }')"
[ -z "$FREE" ] && exit 0
USED=$((100 - FREE))

if [ "$FREE" -lt 10 ]; then
  COLOR=$RED
elif [ "$FREE" -lt 20 ]; then
  COLOR=$YELLOW
else
  COLOR=$GREEN
fi

sketchybar --set "$NAME" icon.color=$COLOR label="${USED}%"
