#!/bin/bash
# Codex 계정별 주간 사용 가능량과 상태 색상을 갱신
source "$HOME/.config/sketchybar/colors.sh"

USAGE="$(codexbar usage --provider codex --all-accounts --format json 2>/dev/null)" || exit 0
[ -z "$USAGE" ] && exit 0

update_account() {
  local item="$1"
  local email="$2"
  local entry remaining resets label color

  entry="$(printf '%s' "$USAGE" | jq -c --arg email "$email" '[.[] | select(.account == $email)][0] // empty')"
  [ -z "$entry" ] && return

  remaining="$(printf '%s' "$entry" | jq -r '100 - (.usage.secondary.usedPercent // 100)')"
  resets="$(printf '%s' "$entry" | jq -r '.usage.codexResetCredits.availableCount // 0')"
  label="${remaining}%"
  [ "$resets" -gt 0 ] && label="${label}(${resets})"

  if [ "$remaining" -le 10 ]; then
    color="$RED"
  elif [ "$remaining" -le 25 ]; then
    color="$ORANGE"
  elif [ "$remaining" -le 50 ]; then
    color="$YELLOW"
  else
    color="$GREEN"
  fi

  sketchybar --set "$item" label="$label" label.color="$color"
}

update_account codex.x20 'songgoonpro@gmail.com'
update_account codex.x5.primary 'tjdals4047@gmail.com'
update_account codex.x5.secondary 'songgoonpro3@gmail.com'
