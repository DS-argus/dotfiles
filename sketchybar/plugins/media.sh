#!/bin/bash
# Read the system's active media session without fetching artwork.
source "$HOME/.config/sketchybar/colors.sh"
hide_media() {
  sketchybar --set '/media\..*/' drawing=off --set media_group drawing=off
}
MEDIA="$(media-control get --no-artwork 2>/dev/null)" || { hide_media; exit 0; }
if ! printf '%s' "$MEDIA" | jq -e 'type == "object" and .playing == true and (.title | type == "string" and length > 0)' >/dev/null 2>&1; then
  hide_media
  exit 0
fi
TITLE="$(printf '%s' "$MEDIA" | jq -r '.title | gsub("[\\r\\n\\t]"; " ")')"
ARTIST="$(printf '%s' "$MEDIA" | jq -r '(.artist // "") | if length == 0 then "Now Playing" else . end | gsub("[\\r\\n\\t]"; " ")')"
sketchybar --set media.title label="$TITLE" \
           --set media.artist label="$ARTIST" \
           --set '/media\..*/' drawing=on --set media_group drawing=on
