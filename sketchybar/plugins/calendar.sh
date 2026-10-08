#!/bin/bash
# Today/tomorrow's nearest event; native icalBuddy excludes ended events.
source "$HOME/.config/sketchybar/colors.sh"
TODAY="$(date '+%Y-%m-%d')"
RAW="$(icalBuddy -n -nc -npn -nrd -iep 'datetime,title,notes' \
  -po 'datetime,title,notes' -tf 'T%H:%M' -df 'D%Y-%m-%d' \
  -ps $'|\x1f|' -b $'\x1e' eventsToday+1 2>/dev/null)" || exit 0
EVENT="$(printf '%s' "$RAW" | jq -Rsc --arg today "$TODAY" '
  def trim: gsub("^\\s+|\\s+$"; "");
  # Conservative CJK/emoji cell widths keep the fixed text area readable.
  def compact:
    . as $text | explode |
    reduce .[] as $char ({text:"",cells:0,cut:false};
      (if $char >= 768 and $char <= 879 then 0 elif $char >= 4352 then 2 else 1 end) as $width |
      if .cut then . elif .cells + $width > 18 then .cut=true
      else .text += ([$char] | implode) | .cells += $width end) |
    if .cut then .text + "…" else $text end;
  split("\u001e") | map(
    split("\u001f") | select(length >= 2) |
    {datetime:.[0],title:(.[1] | gsub("\\s+"; " ") | trim),notes:(.[2] // "")} |
    select(.title != "") |
    (.notes | (split("\n")[0] // "") | trim) as $kind |
    select($kind != "기념일" and $kind != "공휴일") |
    .date = (try (.datetime | capture("D(?<date>[0-9]{4}-[0-9]{2}-[0-9]{2})").date // "") catch "") |
    .time = (try (.datetime | capture("T(?<time>[0-9]{2}:[0-9]{2})").time // "") catch "") |
    select(.date != "")
  ) |
  sort_by((if .time != "" then 0 else 1 end), .date, .time, .title) | .[:1] |
  map(
    (if .date <= $today then "Today" else "Tomorrow" end) as $day |
    {title:(.title | compact),detail:($day + " · " + (if .time == "" then "All Day" else .time end))}
  ) | first
')" || exit 0
if ! printf '%s' "$EVENT" | jq -e 'type == "object"' >/dev/null 2>&1; then
  sketchybar --set '/upcoming\..*/' drawing=off --set upcoming_group drawing=off \
             --set upcoming.title label="" --set upcoming.detail label=""
  exit 0
fi
TITLE="$(printf '%s' "$EVENT" | jq -r '.title')"
DETAIL="$(printf '%s' "$EVENT" | jq -r '.detail')"
sketchybar --set '/upcoming\..*/' drawing=on --set upcoming_group drawing=on \
           --set upcoming.icon icon.color="$FROST1" \
           --set upcoming.title label="$TITLE" \
           --set upcoming.detail label="$DETAIL" label.color="$FROST1"
