#!/bin/bash
# CPU 전체 사용률을 숫자와 미니 그래프로 표시
source "$HOME/.config/sketchybar/colors.sh"

CORES="$(sysctl -n hw.logicalcpu)"
CPU="$(ps -A -o %cpu= | awk -v cores="$CORES" '{ sum += $1 } END { printf "%.0f", sum / cores }')"
[ -z "$CPU" ] && exit 0
[ "$CPU" -gt 100 ] && CPU=100
POINT="$(awk -v cpu="$CPU" 'BEGIN { printf "%.2f", cpu / 100 }')"

if [ "$CPU" -ge 85 ]; then
  COLOR=$RED
  FILL=0x40bf616a
elif [ "$CPU" -ge 60 ]; then
  COLOR=$YELLOW
  FILL=0x40ebcb8b
else
  COLOR=$FROST1
  FILL=0x4088c0d0
fi

sketchybar --set cpu icon.color=$COLOR label="${CPU}%" \
           --set "$NAME" graph.color=$COLOR graph.fill_color=$FILL \
           --push "$NAME" "$POINT"
