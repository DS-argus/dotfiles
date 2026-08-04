#!/bin/bash
# Docker daemon이 실행 중이면 running/total 컨테이너 수 표시.
source "$HOME/.config/sketchybar/colors.sh"

STATES="$(docker ps -a --format '{{.State}}' 2>/dev/null)" || {
  sketchybar --set "$NAME" drawing=off
  exit 0
}

TOTAL="$(printf '%s\n' "$STATES" | awk 'NF { count++ } END { print count+0 }')"
RUNNING="$(printf '%s\n' "$STATES" | awk '$1 == "running" { count++ } END { print count+0 }')"

if [ "$TOTAL" -eq 0 ]; then
  sketchybar --set "$NAME" drawing=off
else
  [ "$RUNNING" -gt 0 ] && COLOR=$FROST1 || COLOR=$MUTED
  sketchybar --set "$NAME" drawing=on icon.color=$COLOR label="$RUNNING/$TOTAL"
fi
