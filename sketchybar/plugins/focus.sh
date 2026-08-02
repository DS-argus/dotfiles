#!/bin/bash
# 집중 모드(방해금지) 활성 시에만 아이콘 표시
ASSERT="$HOME/Library/DoNotDisturb/DB/Assertions.json"

if [ -f "$ASSERT" ] && plutil -extract data.0.storeAssertionRecords json -o - "$ASSERT" >/dev/null 2>&1; then
  sketchybar --set "$NAME" drawing=on
else
  sketchybar --set "$NAME" drawing=off
fi
