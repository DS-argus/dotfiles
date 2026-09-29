#!/bin/bash
source "$HOME/.config/sketchybar/colors.sh"

BATTERY="$(pmset -g batt)"
PERCENTAGE="$(printf '%s\n' "$BATTERY" | grep -Eo '[0-9]+%' | cut -d% -f1)"
AC_POWER="$(printf '%s\n' "$BATTERY" | grep 'AC Power')"

[ -z "$PERCENTAGE" ] && exit 0

if [ -n "$AC_POWER" ]; then
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
  STATUS="AC Power"
elif printf '%s\n' "$BATTERY" | grep -q '; charging'; then
  STATUS="Charging"
elif printf '%s\n' "$BATTERY" | grep -q 'discharging'; then
  STATUS="On Battery"
elif printf '%s\n' "$BATTERY" | grep -q 'charged'; then
  STATUS="Charged"
else
  STATUS="$SOURCE"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color=$COLOR label="${PERCENTAGE}%" \
           --set battery.status label="$STATUS"
