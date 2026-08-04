#!/bin/bash
# 읽지 않은 GitHub 알림. gh 인증/네트워크 실패 또는 0개면 숨김.
source "$HOME/.config/sketchybar/colors.sh"

COUNT="$(gh api --method GET notifications -f per_page=100 --cache 5m --jq 'length' 2>/dev/null)"

if ! [[ "$COUNT" =~ ^[0-9]+$ ]] || [ "$COUNT" -eq 0 ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

if [ "$COUNT" -ge 10 ]; then
  COLOR=$RED
else
  COLOR=$FROST1
fi

sketchybar --set "$NAME" drawing=on icon.color=$COLOR label="$COUNT"
