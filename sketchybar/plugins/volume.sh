#!/bin/bash
# 볼륨 상태, 팝업 토글, 스크롤 조절
source "$HOME/.config/sketchybar/colors.sh"

if [ "$SENDER" = "mouse.clicked" ]; then
  if [ "$BUTTON" = "right" ]; then
    open 'x-apple.systempreferences:com.apple.Sound-Settings.extension'
  else
    sketchybar --set battery popup.drawing=off \
               --set dev_network popup.drawing=off \
               --set wifi popup.drawing=off \
               --set bluetooth popup.drawing=off \
               --set "$NAME" popup.drawing=toggle
  fi
  exit 0
fi

if [ "$SENDER" = "mouse.scrolled" ]; then
  CURRENT="$(osascript -e 'output volume of (get volume settings)')"
  TARGET="$(awk -v current="$CURRENT" -v delta="$SCROLL_DELTA" 'BEGIN {
    value = current + (delta > 0 ? 5 : -5)
    if (value < 0) value = 0
    if (value > 100) value = 100
    printf "%.0f", value
  }')"
  osascript -e "set volume output volume $TARGET"
  exit 0
fi

VOLUME="${INFO:-$(osascript -e 'output volume of (get volume settings)')}"
MUTED="$(osascript -e 'output muted of (get volume settings)')"

case "$VOLUME" in
  [6-9][0-9]|100) ICON="󰕾" ;;
  [3-5][0-9])     ICON="󰖀" ;;
  [1-9]|[1-2][0-9]) ICON="󰕿" ;;
  *)              ICON="󰝟" ;;
esac

[ "$MUTED" = "true" ] && MUTE_LABEL="Unmute" || MUTE_LABEL="Mute"

sketchybar --set "$NAME" icon="$ICON" label="${VOLUME}%" \
           --set volume.slider slider.percentage="$VOLUME" \
           --set volume.mute label="$MUTE_LABEL"
