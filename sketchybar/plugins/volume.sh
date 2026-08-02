#!/bin/bash
# volume_change 이벤트가 $INFO로 볼륨(0-100) 전달
source "$HOME/.config/sketchybar/colors.sh"

VOLUME="${INFO:-$(osascript -e 'output volume of (get volume settings)')}"

case "$VOLUME" in
  [6-9][0-9]|100) ICON="󰕾" ;;
  [3-5][0-9])     ICON="󰖀" ;;
  [1-9]|[1-2][0-9]) ICON="󰕿" ;;
  *)              ICON="󰝟" ;;
esac

sketchybar --set "$NAME" icon="$ICON" label="${VOLUME}%"
