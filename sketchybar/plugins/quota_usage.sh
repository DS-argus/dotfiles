#!/bin/bash
# Shared Bash/jq quota cache. The two providers run independently.
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/accounts.local.sh" 2>/dev/null || exit 0
PROVIDER="$1"
case "$PROVIDER" in
  codex)
    ITEMS=(codex.x20 codex.x5.primary codex.x5.secondary)
    ACCOUNTS=("$SKETCHYBAR_CODEX_X20_ACCOUNT" "$SKETCHYBAR_CODEX_X5_PRIMARY_ACCOUNT" "$SKETCHYBAR_CODEX_X5_SECONDARY_ACCOUNT")
    for account in "${ACCOUNTS[@]}"; do [ -n "$account" ] || exit 0; done
    ;;
  claude) [ -n "$SKETCHYBAR_CLAUDE_ACCOUNT" ] || exit 0 ;;
  *) exit 0 ;;
esac

INTERVAL=300
NOW="$(date +%s)"
umask 077
STATE_DIR="${SKETCHYBAR_QUOTA_STATE_DIR:-/tmp/sketchybar-quota-${UID}}"
mkdir -m 700 "$STATE_DIR" 2>/dev/null
[[ -d "$STATE_DIR" && -O "$STATE_DIR" && ! -L "$STATE_DIR" ]] || exit 0
CACHE="$STATE_DIR/$PROVIDER.json"
LOCK="$STATE_DIR/$PROVIDER.lock"
if [ "$PROVIDER" = codex ]; then
  SCOPE="$(printf '%s\n' "${ACCOUNTS[@]}" | jq -Rsc 'split("\n")[:-1]')"
else
  SCOPE="$(jq -cn --arg account "$SKETCHYBAR_CLAUDE_ACCOUNT" '[$account]')"
fi
EMPTY="$(jq -cn --argjson scope "$SCOPE" '{scope:$scope,entries:[],fetchedAt:0,lastAttempt:0,failed:false}')"
read_cache() {
  jq -ce --argjson scope "$SCOPE" '
    select(.scope == $scope and (.entries | type == "array")) |
    .fetchedAt = ((.fetchedAt // 0) | floor) | .lastAttempt = ((.lastAttempt // 0) | floor)
  ' "$CACHE" 2>/dev/null
}
STATE="$(read_cache)"
[ -n "$STATE" ] || STATE="$EMPTY"

# Preserve the former Claude cache when moving from the Python renderer.
if [ "$PROVIDER" = claude ] && [ ! -f "$CACHE" ]; then
  LEGACY="${TMPDIR:-/tmp}/sketchybar-claude-${UID}/quota.json"
  MIGRATED="$(jq -ce --arg account "$SKETCHYBAR_CLAUDE_ACCOUNT" --argjson scope "$SCOPE" '
    select(.account == $account and (.snapshot.usage.primary.usedPercent | type == "number")
      and (.snapshot.usage.secondary.usedPercent | type == "number")) |
    {scope:$scope,entries:[{account:$account,usage:.snapshot.usage}],
     fetchedAt:(.snapshot.fetchedAt | floor),lastAttempt:((.lastAttempt // 0) | floor),failed:(.error // false)}
  ' "$LEGACY" 2>/dev/null)"
  [ -z "$MIGRATED" ] || STATE="$MIGRATED"
fi

remaining_color() {
  if [ "$1" -le 10 ]; then COLOR=$RED
  elif [ "$1" -le 25 ]; then COLOR=$ORANGE
  elif [ "$1" -le 50 ]; then COLOR=$YELLOW
  else COLOR=$GREEN; fi
}

countdown() {
  local epoch seconds minutes
  epoch="$(printf '%s' "$1" | jq -r 'try (.resetsAt | sub("\\.[0-9]+Z$";"Z") | fromdateiso8601) catch empty')"
  COUNTDOWN="--"
  [[ "$epoch" =~ ^[0-9]+$ ]] || return 0
  seconds=$((epoch - NOW)); [ "$seconds" -ge 0 ] || seconds=0
  minutes=$((seconds / 60))
  if [ "$minutes" -ge 1440 ]; then
    COUNTDOWN="$((minutes / 1440))d $((minutes % 1440 / 60))h"
  else
    COUNTDOWN="$((minutes / 60))h $((minutes % 60))m"
  fi
}

render_window() {
  local item="$1" window="$2" stale="$3" remaining label
  remaining="$(printf '%s' "$window" | jq -r '
    if (.usedPercent | type) == "number" then
      [0, ([100, ((100 - .usedPercent + 0.5) | floor)] | min)] | max
    else empty end')"
  label=" --%"; COLOR=$MUTED
  if [[ "$remaining" =~ ^[0-9]+$ ]]; then
    printf -v label '%4s' "${remaining}%"
    [ "$stale" = false ] || [ "$stale" = 0 ] || remaining=""
    [ -z "$remaining" ] || remaining_color "$remaining"
  fi
  countdown "$window"
  DRAW+=(--set "$item" label="$label" label.color="$COLOR"
         --set "$item.reset" label="$COUNTDOWN")
}

render() {
  local fetched failed stale item entry window row i width offset credits drawing
  NOW="$(date +%s)"
  fetched="$(printf '%s' "$STATE" | jq -r '.fetchedAt // 0')"
  failed="$(printf '%s' "$STATE" | jq -r '.failed // false')"
  stale=false
  [ "$failed" = false ] && [ $((NOW - fetched)) -le $((INTERVAL * 2)) ] || stale=true
  DRAW=()
  if [ "$PROVIDER" = claude ]; then
    COLOR=$ORANGE; [ "$stale" = false ] || COLOR=$RED
    DRAW+=(--set claude.logo icon.color="$COLOR")
    for row in session weekly; do
      [ "$row" != session ] && field=secondary || field=primary
      window="$(printf '%s' "$STATE" | jq -c --arg field "$field" '.entries[0].usage[$field] // {}')"
      render_window "claude.$row" "$window" "$stale"
    done
  else
    ACTIVE=()
    for i in "${!ITEMS[@]}"; do
      if [ "$fetched" -eq 0 ] || printf '%s' "$STATE" | jq -e --arg account "${ACCOUNTS[$i]}" 'any(.entries[]; .account == $account)' >/dev/null; then ACTIVE+=("$i"); fi
      for suffix in "" .reset .credits .tier; do DRAW+=(--set "${ITEMS[$i]}$suffix" drawing=off width=0); done
    done
    row=0
    for i in "${ACTIVE[@]}"; do
      item="${ITEMS[$i]}"
      offset=$(((${#ACTIVE[@]} - 1) * 6 - row * 12))
      for suffix in "" .reset .credits .tier; do
        width=0
        if [ "$row" -eq 0 ]; then
          case "$suffix" in "") width=30 ;; .reset) width=48 ;; .credits) width=24 ;; .tier) width=24 ;; esac
        fi
        DRAW+=(--set "$item$suffix" drawing=on width="$width" label.y_offset="$offset")
      done
      entry="$(printf '%s' "$STATE" | jq -c --arg account "${ACCOUNTS[$i]}" '[.entries[] | select(.account == $account)][0] // {}')"
      window="$(printf '%s' "$entry" | jq -c '.usage.secondary // {}')"
      entry_stale="$stale"
      if [ "$(printf '%s' "$entry" | jq -r '.stale // false')" = true ]; then entry_stale=true; failed=true; fi
      render_window "$item" "$window" "$entry_stale"
      credits="$(printf '%s' "$entry" | jq -r '.usage.codexResetCredits.availableCount // 0')"
      label=""; [ "$credits" -le 0 ] || label="($credits)"
      DRAW+=(--set "$item.credits" label="$label")
      row=$((row + 1))
    done
    drawing=off; [ "${#ACTIVE[@]}" -eq 0 ] || drawing=on
    COLOR=$FROST2; [ "$stale" = false ] && [ "$failed" = false ] || COLOR=$RED
    DRAW+=(--set codex_usage drawing="$drawing" icon.color="$COLOR"
           --set quota.divider drawing="$drawing" --set codex_group drawing=on)
  fi
  sketchybar "${DRAW[@]}"
}

save_state() {
  local temporary
  temporary="$(mktemp "$STATE_DIR/state.XXXXXX")" || return 1
  printf '%s\n' "$STATE" > "$temporary"
  mv -f "$temporary" "$CACHE"
}

# Bash job control gives the probe its own group so a timeout also stops children.
run_bounded() {
  local limit="$1" output="$2" probe timer status
  shift 2
  set -m
  "$@" > "$output" 2>/dev/null &
  probe=$!
  (
    sleep "$limit"
    kill -TERM -- "-$probe" 2>/dev/null
    sleep 2
    kill -KILL -- "-$probe" 2>/dev/null
  ) >/dev/null 2>&1 &
  timer=$!
  set +m
  wait "$probe"; status=$?
  kill -TERM -- "-$timer" 2>/dev/null
  wait "$timer" 2>/dev/null
  return "$status"
}

render
if ! mkdir "$LOCK" 2>/dev/null; then
  owner="$(cat "$LOCK/pid" 2>/dev/null)"
  [[ "$owner" =~ ^[0-9]+$ ]] && kill -0 "$owner" 2>/dev/null && exit 0
  created="$(stat -f %m "$LOCK" 2>/dev/null)"
  [[ "$created" =~ ^[0-9]+$ ]] && [ $((NOW - created)) -gt 5 ] || exit 0
  rm -f "$LOCK/pid"; rmdir "$LOCK" 2>/dev/null || exit 0
  mkdir "$LOCK" 2>/dev/null || exit 0
fi
printf '%s\n' "$$" > "$LOCK/pid"
PAYLOAD="$(mktemp "$STATE_DIR/probe.XXXXXX")" || exit 0
AUTH="$(mktemp "$STATE_DIR/auth.XXXXXX")" || exit 0
cleanup() { rm -f "$PAYLOAD" "$AUTH" "$LOCK/pid"; rmdir "$LOCK" 2>/dev/null; }
trap cleanup EXIT
trap 'exit 0' TERM INT HUP
LATEST="$(read_cache)"
[ -z "$LATEST" ] || STATE="$LATEST"
NOW="$(date +%s)"
attempt="$(printf '%s' "$STATE" | jq -r '.lastAttempt // 0')"
[ $((NOW - attempt)) -ge "$INTERVAL" ] || exit 0
STATE="$(printf '%s' "$STATE" | jq -c --argjson now "$NOW" '.lastAttempt=$now')"
save_state
success=false
if [ "$PROVIDER" = codex ]; then
  if run_bounded 45 "$PAYLOAD" codexbar usage --provider codex --all-accounts --format json &&
    jq -e 'type == "array" and all(.[]; (.account | type) == "string")' "$PAYLOAD" >/dev/null 2>&1; then
    ENTRIES="$(jq -c --argjson old "$STATE" '
      map(. as $new | if (.usage.secondary.usedPercent | type) == "number" and .error == null then
        {account:.account,usage:{secondary:.usage.secondary,codexResetCredits:.usage.codexResetCredits},stale:false}
      else (($old.entries | map(select(.account == $new.account)) | first) // {account:$new.account}) + {stale:true} end)
    ' "$PAYLOAD")"
    success=true
  fi
else
  if run_bounded 6 "$AUTH" claude auth status --json &&
    jq -e --arg account "$SKETCHYBAR_CLAUDE_ACCOUNT" '.loggedIn == true and ((.email // "") | ascii_downcase) == ($account | ascii_downcase)' "$AUTH" >/dev/null 2>&1 &&
    run_bounded 45 "$PAYLOAD" codexbar usage --provider claude --source cli --json --no-credits; then
    ENTRIES="$(jq -ce --arg account "$SKETCHYBAR_CLAUDE_ACCOUNT" '
      [.[] | select(.provider == "claude" and .error == null and (.usage.primary.usedPercent | type) == "number"
        and (.usage.secondary.usedPercent | type) == "number"
        and ((.usage.identity.accountEmail // $account | ascii_downcase) == ($account | ascii_downcase))) |
        {account:$account,usage:{primary:.usage.primary,secondary:.usage.secondary}}] |
      select(length == 1)
    ' "$PAYLOAD" 2>/dev/null)" && success=true
  fi
fi
if [ "$success" = true ]; then
  STATE="$(printf '%s' "$STATE" | jq -c --argjson entries "$ENTRIES" --argjson now "$(date +%s)" '.entries=$entries | .fetchedAt=$now | .failed=false')"
else
  STATE="$(printf '%s' "$STATE" | jq -c '.failed=true')"
fi
save_state
render
