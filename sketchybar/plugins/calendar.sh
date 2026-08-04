#!/bin/bash
# 지금부터 24시간 안의 가장 가까운 시간 지정 일정 하나를 표시.
source "$HOME/.config/sketchybar/colors.sh"

START="$(date '+%Y-%m-%d %H:%M:%S')"
END="$(date -v+24H '+%Y-%m-%d %H:%M:%S')"
EVENT="$(icalBuddy -n -nc -npn -nrd -ea -eed -li 1 \
  -tf '%H:%M' -df '' -po 'datetime,title' -ps '| |' -b '' \
  "eventsFrom:$START" "to:$END" 2>/dev/null | tr '\n' ' ' | sed 's/[[:space:]]*$//')"

if [ -n "$EVENT" ]; then
  sketchybar --set "$NAME" drawing=on label="$EVENT"
else
  sketchybar --set "$NAME" drawing=off label=""
fi
