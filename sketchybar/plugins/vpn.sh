#!/bin/bash
# VPN 연결 시에만 아이콘 표시 (scutil 프로필 + tailscale/wireguard utun 라우팅)
if scutil --nc list 2>/dev/null | grep -q Connected \
  || netstat -rn -f inet 2>/dev/null | awk '$1=="default"{print $NF}' | grep -q '^utun'; then
  sketchybar --set "$NAME" drawing=on
else
  sketchybar --set "$NAME" drawing=off
fi
