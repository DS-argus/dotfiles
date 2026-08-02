#!/bin/bash
# AeroSpace 바인딩 모드: service 모드일 때만 경고색 배지 표시
if [ "$MODE" = "service" ]; then
  sketchybar --set "$NAME" drawing=on
else
  sketchybar --set "$NAME" drawing=off
fi
