#!/bin/bash
source "$HOME/.config/sketchybar/colors.sh"
case "$1" in
  media)
    BUNDLE="$(media-control get --no-artwork 2>/dev/null | jq -r '.bundleIdentifier // empty')"
    [ -n "$BUNDLE" ] && open -b "$BUNDLE"
    ;;
  current)
    APP="$(aerospace list-windows --focused --format '%{app-name}' 2>/dev/null)"
    [ -n "$APP" ] && open -a "$APP"
    ;;
esac
