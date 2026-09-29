#!/bin/bash
# macOS memory pressure 기반 가용량을 사용률 형태로 표시
source "$HOME/.config/sketchybar/colors.sh"

FREE="$(memory_pressure -Q 2>/dev/null | awk '/System-wide memory free percentage:/ { gsub(/%/, "", $5); print $5 }')"
[ -z "$FREE" ] && exit 0
USED=$((100 - FREE))
POINT="$(awk -v used="$USED" 'BEGIN { printf "%.2f", used / 100 }')"

if [ "$FREE" -lt 10 ]; then
  COLOR=$RED
  FILL=0x40bf616a
elif [ "$FREE" -lt 20 ]; then
  COLOR=$YELLOW
  FILL=0x40ebcb8b
else
  COLOR=$PURPLE
  FILL=0x40b48ead
fi

sketchybar --set "$NAME" icon.color=$COLOR label="RAM ${USED}%" \
           --set memory_graph graph.color=$COLOR graph.fill_color=$FILL \
           --push memory_graph "$POINT"
