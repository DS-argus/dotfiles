#!/bin/bash
# Codex 계정별 주간 사용 가능량과 상태 색상을 갱신
source "$HOME/.config/sketchybar/colors.sh"

USAGE="$(codexbar usage --provider codex --all-accounts --format json 2>/dev/null)" || exit 0
# A failed/malformed fetch must not be interpreted as account removal.
printf '%s' "$USAGE" | jq -e '
  type == "array" and all(.[]; type == "object" and (.account | type == "string"))
' >/dev/null 2>&1 || exit 0

ITEMS=(codex.x20 codex.x5.primary codex.x5.secondary)
ACCOUNTS=('songgoonpro@gmail.com' 'tjdals4047@gmail.com' 'songgoonpro3@gmail.com')
ACTIVE=()
for i in "${!ITEMS[@]}"; do
  if printf '%s' "$USAGE" | jq -e --arg account "${ACCOUNTS[$i]}" 'any(.[]; .account == $account)' >/dev/null; then
    ACTIVE+=("$i")
  fi
done

# The first visible row owns each column's width. Other rows overlay it.
# This also works when the former width owner (x20) is removed.
LAYOUT=()
for item in "${ITEMS[@]}"; do
  for suffix in "" .reset .credits .tier; do
    LAYOUT+=(--set "$item$suffix" drawing=off width=0)
  done
done
count=${#ACTIVE[@]}
row=0
for i in "${ACTIVE[@]}"; do
  offset=$(((count - 1) * 6 - row * 12))
  for suffix in "" .reset .credits .tier; do
    width=0
    if [ "$row" -eq 0 ]; then
      case "$suffix" in
        "") width=30 ;; .reset) width=42 ;; .credits) width=24 ;; .tier) width=24 ;;
      esac
    fi
    LAYOUT+=(--set "${ITEMS[$i]}$suffix" drawing=on width="$width" label.y_offset="$offset")
  done
  row=$((row + 1))
done
drawing=off
[ "$count" -gt 0 ] && drawing=on
LAYOUT+=(--set codex_usage drawing="$drawing" --set codex_separator drawing="$drawing" --set codex_group drawing="$drawing")
sketchybar "${LAYOUT[@]}"


update_account() {
  local item="$1"
  local email="$2"
  local entry remaining resets label color reset_epoch seconds days hours countdown credits

  entry="$(printf '%s' "$USAGE" | jq -c --arg email "$email" '[.[] | select(.account == $email)][0] // empty')"
  [ -z "$entry" ] && return 0
  # An account-specific error keeps its row and last successful values.
  printf '%s' "$entry" | jq -e '.usage.secondary.usedPercent | type == "number"' >/dev/null 2>&1 || return 0

  remaining="$(printf '%s' "$entry" | jq -r '100 - (.usage.secondary.usedPercent // 100)')"
  resets="$(printf '%s' "$entry" | jq -r '.usage.codexResetCredits.availableCount // 0')"
  # Weekly reset countdown, calculated from the absolute timestamp.
  reset_epoch="$(printf '%s' "$entry" | jq -r 'try (.usage.secondary.resetsAt | fromdateiso8601) catch empty')"
  countdown="--"
  if [[ "$reset_epoch" =~ ^[0-9]+$ ]]; then
    seconds=$((reset_epoch - $(date +%s)))
    [ "$seconds" -lt 0 ] && seconds=0
    days=$((seconds / 86400))
    hours=$((seconds % 86400 / 3600))
    countdown="${days}d ${hours}h"
  fi
  credits=""
  [ "$resets" -gt 0 ] && credits="($resets)"
  printf -v label '%4s' "${remaining}%"

  if [ "$remaining" -le 10 ]; then
    color="$RED"
  elif [ "$remaining" -le 25 ]; then
    color="$ORANGE"
  elif [ "$remaining" -le 50 ]; then
    color="$YELLOW"
  else
    color="$GREEN"
  fi

  sketchybar --set "$item" label="$label" label.color="$color" \
             --set "$item.reset" label="$countdown" label.color="$FROST2" \
             --set "$item.credits" label="$credits" label.color="$PURPLE"
}

for i in "${ACTIVE[@]}"; do
  update_account "${ITEMS[$i]}" "${ACCOUNTS[$i]}"
done
