#!/bin/bash
# 포커스된 앱 이름 표시 (front_app_switched 이벤트가 $INFO로 앱 이름 전달)
if [ "$SENDER" = "front_app_switched" ]; then
  APP_NAME="$INFO"
  [ "$APP_NAME" = "Google Chrome" ] && APP_NAME="Chrome"
  sketchybar --set "$NAME" label="$APP_NAME"
fi
