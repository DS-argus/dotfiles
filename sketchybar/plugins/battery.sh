#!/bin/bash
source "$HOME/.config/sketchybar/colors.sh"

if [ "$SENDER" = "mouse.clicked" ]; then
  if [ "$BUTTON" = "right" ]; then
    open 'x-apple.systempreferences:com.apple.Battery-Settings.extension'
  else
    sketchybar --set volume popup.drawing=off \
               --set dev_network popup.drawing=off \
               --set wifi popup.drawing=off \
               --set bluetooth popup.drawing=off \
               --set "$NAME" popup.drawing=toggle
  fi
  exit 0
fi

BATTERY="$(pmset -g batt)"
PERCENTAGE="$(printf '%s\n' "$BATTERY" | grep -Eo '[0-9]+%' | cut -d% -f1)"
CHARGING="$(printf '%s\n' "$BATTERY" | grep 'AC Power')"

[ -z "$PERCENTAGE" ] && exit 0

if [ -n "$CHARGING" ]; then
  ICON="󰂄" COLOR=$GREEN SOURCE="AC Power"
else
  SOURCE="Battery"
  case "$PERCENTAGE" in
    9[0-9]|100) ICON="󰁹" COLOR=$GREEN ;;
    [6-8][0-9]) ICON="󰂀" COLOR=$TEXT ;;
    [3-5][0-9]) ICON="󰁾" COLOR=$YELLOW ;;
    [1-2][0-9]) ICON="󰁻" COLOR=$ORANGE ;;
    *)          ICON="󰂃" COLOR=$RED ;;
  esac
fi

if printf '%s\n' "$BATTERY" | grep -q 'not charging'; then
  DETAIL="Not Charging"
elif printf '%s\n' "$BATTERY" | grep -q '; charging'; then
  DETAIL="Charging"
elif printf '%s\n' "$BATTERY" | grep -q 'discharging'; then
  TIME_LEFT="$(printf '%s\n' "$BATTERY" | grep -Eo '[0-9]+:[0-9]+ remaining' | cut -d' ' -f1)"
  DETAIL="Time Remaining · ${TIME_LEFT:-Calculating}"
elif printf '%s\n' "$BATTERY" | grep -q 'charged'; then
  DETAIL="Fully Charged"
else
  DETAIL="Status Unavailable"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color=$COLOR label="${PERCENTAGE}%" \
           --set battery.source label="$SOURCE · ${PERCENTAGE}%" \
           --set battery.detail label="${DETAIL:-Status Unavailable}"
