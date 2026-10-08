#!/bin/bash
# Portrait displays keep workspaces and the clock; landscape displays show all.
# The laptop screen alone moves the media/calendar islands next to the workspaces.
source "$HOME/.config/sketchybar/colors.sh"
DISPLAYS="$(sketchybar --query displays)" || exit 0
TARGETS="$(printf '%s' "$DISPLAYS" | jq -er '
  if type != "array" or length == 0 then error("no displays") else
    ([.[] | select(.frame.w >= .frame.h) | .["arrangement-id"]]) as $wide
    # Keep the full controls available if every connected screen is portrait.
    | (if ($wide | length) > 0 then $wide else [.[0]["arrangement-id"]] end)
    | map(tostring) | join(",")
  end
')" || exit 0

# Display association is independent of drawing, so account/status updates can
# show or hide rows without accidentally restoring them on portrait monitors.
ARGS=()
for item in clock calendar system_group mode battery battery.status \
  github cpu_graph memory_graph network.up \
  network.down system_separator codex_usage \
  codex_separator codex_group '/codex\..*/' claude_usage '/claude\..*/' quota.divider media_group '/media\..*/' upcoming_group '/upcoming\..*/'; do
  ARGS+=(--set "$item" display="$TARGETS")
done
# The compact clock is only needed on displays not receiving the full bar.
PORTRAITS="$(printf '%s' "$DISPLAYS" | jq -r --arg full "$TARGETS" '
  ($full | split(",")) as $ids |
  [.[] | .["arrangement-id"] | tostring | select(. as $id | $ids | index($id) | not)] | join(",")
')"
for item in portrait.clock portrait.calendar portrait_clock_group; do
  if [ -n "$PORTRAITS" ]; then
    ARGS+=(--set "$item" display="$PORTRAITS" drawing=on)
  else
    ARGS+=(--set "$item" drawing=off)
  fi
done
ALL_DISPLAYS="$(printf '%s' "$DISPLAYS" | jq -r '[.[] | .["arrangement-id"] | tostring] | join(",")')"
ARGS+=(--set front_app display="$ALL_DISPLAYS")
sketchybar "${ARGS[@]}"

# Laptop screen only: media/calendar islands sit right after the workspaces.
# Bar order per side; the separator leads on the left and trails on the right.
LEFT_ORDER=(media.separator media.icon media.artist media.title upcoming.separator upcoming.icon upcoming.detail upcoming.title)
RIGHT_ORDER=(upcoming.separator upcoming.detail upcoming.title upcoming.icon media.separator media.artist media.title media.icon)
MONITORS="$(aerospace list-monitors --format '%{monitor-name}')" || exit 0
SIDE=right
printf '%s\n' "$MONITORS" | grep -viq 'built-in' || SIDE=left
[ "$(sketchybar --query upcoming.title | jq -r '.geometry.position')" = "$SIDE" ] && exit 0
if [ "$SIDE" = left ]; then ORDER=("${LEFT_ORDER[@]}"); else ORDER=("${RIGHT_ORDER[@]}"); fi
sketchybar --set '/media\..*/' position="$SIDE" --set '/upcoming\..*/' position="$SIDE" \
  --reorder "${ORDER[@]}"
