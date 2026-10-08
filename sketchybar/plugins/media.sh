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
# Fit each label to its slot using CoreText advances measured for Hack Nerd Font Bold and its
# macOS fallbacks. SketchyBar truncates by code point, so it receives the same NFC text measured here.
FITTED="$(python3 - "$TITLE" "$ARTIST" "${MEDIA_FONT_SIZE:-10}" "${MEDIA_TEXT_WIDTH:-164}" <<'PYTHON'
import sys
import unicodedata

HACK_RANGES = ((0x20, 0x7E), (0xA0, 0x17F), (0x384, 0x3CE), (0x400, 0x45F), (0x2000, 0x2027))
# Rendered width is glyph bounds + 1.5px; it must stay within label.width or scrolling turns off.
budget = (float(sys.argv[4]) - 4) / float(sys.argv[3])

def advance(char):
    code = ord(char)
    if unicodedata.category(char) in ("Mn", "Cf"):
        return 0.5 if char == "\ufe0f" else 0.0
    if any(low <= code <= high for low, high in HACK_RANGES):
        return 0.603
    if 0x1E00 <= code <= 0x1EFF:
        return 0.95
    if 0xAC00 <= code <= 0xD7A3 or 0x3131 <= code <= 0x318E:
        return 0.866
    wide = unicodedata.east_asian_width(char) in "WF"
    if 0x1F000 <= code <= 0x1FAFF or (wide and code < 0x2E80):
        return 1.41
    if wide and code <= 0xFFFF:
        return 1.0
    return 1.1

def fitted_count(text):
    used = 0.0
    for count, char in enumerate(text):
        used += advance(char)
        if used > budget:
            return max(1, count)
    return len(text)

title, artist = (unicodedata.normalize("NFC", text) for text in sys.argv[1:3])
print(fitted_count(title), fitted_count(artist))
print(title)
print(artist)
PYTHON
)" || exit 0
{ read -r TITLE_CHARS ARTIST_CHARS; IFS= read -r TITLE; IFS= read -r ARTIST; } <<< "$FITTED"
# max_chars must precede label: SketchyBar computes the clip width when the label changes.
sketchybar --set media.title label.max_chars="$TITLE_CHARS" label="$TITLE" \
           --set media.artist label.max_chars="$ARTIST_CHARS" label="$ARTIST" \
           --set '/media\..*/' drawing=on --set media_group drawing=on
