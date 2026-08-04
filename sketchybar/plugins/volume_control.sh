#!/bin/bash
# 팝업 슬라이더와 음소거 버튼 처리

[ "$SENDER" = "mouse.clicked" ] || exit 0
if [ "$NAME" = "volume.slider" ]; then
  osascript -e "set volume output volume ${PERCENTAGE:-0}"
elif [ "$NAME" = "volume.mute" ]; then
  osascript -e 'set volume output muted (not (output muted of (get volume settings)))'
fi
