#!/bin/bash
# 한/영 입력소스 표시: 한글 IME면 "한", 아니면 "A"
source "$HOME/.config/sketchybar/colors.sh"

if defaults read com.apple.HIToolbox AppleSelectedInputSources 2>/dev/null \
    | grep -q 'inputmethod.Korean'; then
  sketchybar --set "$NAME" icon="한" icon.color=$YELLOW
else
  sketchybar --set "$NAME" icon="A" icon.color=$FROST1
fi
