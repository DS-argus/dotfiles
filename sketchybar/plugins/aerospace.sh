#!/bin/bash
# 워크스페이스 인디케이터: 숫자 + 해당 워크스페이스의 앱 아이콘 스트립
# 포커스 = frost1 배경 + 어두운 렌더링, 비포커스 = 흰색, 빈 곳 = 숨김
source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/plugins/icon_map.sh"

SID="$1"
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"

# 워크스페이스 안의 앱들 → 아이콘 글리프
ICON_STRIP=""
while IFS= read -r app; do
  [ -z "$app" ] && continue
  __icon_map "$app"
  ICON_STRIP+=" $icon_result"
done <<EOF
$(aerospace list-windows --workspace "$SID" --format '%{app-name}' 2>/dev/null | sort -u)
EOF

if [ -n "$ICON_STRIP" ]; then
  LABEL_ARGS=(label="$ICON_STRIP" label.drawing=on)
else
  LABEL_ARGS=(label.drawing=off)
fi

if [ "$SID" = "$FOCUSED" ]; then
  sketchybar --set "$NAME" drawing=on \
    icon.highlight=on \
    label.color=$BG_DARK \
    background.drawing=on \
    "${LABEL_ARGS[@]}"
elif [ -n "$ICON_STRIP" ]; then
  sketchybar --set "$NAME" drawing=on \
    icon.highlight=off \
    icon.color=$TEXT \
    label.color=$TEXT \
    background.drawing=off \
    "${LABEL_ARGS[@]}"
else
  sketchybar --set "$NAME" drawing=off
fi
