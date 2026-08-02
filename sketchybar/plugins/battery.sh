#!/bin/bash
source "$HOME/.config/sketchybar/colors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo '[0-9]+%' | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

[ -z "$PERCENTAGE" ] && exit 0

if [ -n "$CHARGING" ]; then
  ICON="󰂄" COLOR=$GREEN
else
  case "$PERCENTAGE" in
    9[0-9]|100) ICON="󰁹" COLOR=$GREEN ;;
    [6-8][0-9]) ICON="󰂀" COLOR=$TEXT ;;
    [3-5][0-9]) ICON="󰁾" COLOR=$YELLOW ;;
    [1-2][0-9]) ICON="󰁻" COLOR=$ORANGE ;;
    *)          ICON="󰂃" COLOR=$RED ;;
  esac
fi

sketchybar --set "$NAME" icon="$ICON" icon.color=$COLOR label="${PERCENTAGE}%"
