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
# Conservative display-cell estimate: wide/CJK/emoji characters count as two.
# Python is already used by calendar.sh; no native helper or on-disk cache needed.
COUNTS="$(python3 - "$TITLE" "$ARTIST" "${MEDIA_FONT_SIZE:-11}" "${MEDIA_TEXT_WIDTH:-180}" <<'PYTHON'
import sys
import unicodedata

budget = max(1, int((float(sys.argv[4]) - 10) / (float(sys.argv[3]) * 0.62)))

def fitted_count(text):
    used = count = 0
    for char in text:
        if unicodedata.combining(char) or unicodedata.category(char) == "Cf" or char in "\ufe0e\ufe0f":
            cells = 0
        else:
            cells = 2 if unicodedata.east_asian_width(char) in "WFA" or ord(char) >= 0x1F000 else 1
        if used + cells > budget:
            break
        used += cells
        count += 1
    return max(1, count)

print(fitted_count(sys.argv[1]), fitted_count(sys.argv[2]))
PYTHON
)" || exit 0
read -r TITLE_CHARS ARTIST_CHARS <<< "$COUNTS"
sketchybar --set media.title label="$TITLE" label.max_chars="$TITLE_CHARS" \
           --set media.artist label="$ARTIST" label.max_chars="$ARTIST_CHARS" \
           --set '/media\..*/' drawing=on --set media_group drawing=on
