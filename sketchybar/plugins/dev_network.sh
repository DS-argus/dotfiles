#!/bin/bash
# VPN 연결 시 아이콘만 표시하고, 상세 정보는 팝업에 둔다.
source "$HOME/.config/sketchybar/colors.sh"

if [ "$SENDER" = "mouse.clicked" ]; then
  if [ "$BUTTON" = "right" ]; then
    open -a Tailscale
  else
    sketchybar --set volume popup.drawing=off \
               --set battery popup.drawing=off \
               --set wifi popup.drawing=off \
               --set bluetooth popup.drawing=off \
               --set "$NAME" popup.drawing=toggle
  fi
  exit 0
fi

if command -v tailscale >/dev/null 2>&1; then
  TS="$(tailscale status --json 2>/dev/null | python3 -c '
import json, sys
try:
    data = json.load(sys.stdin)
    ips = data.get("TailscaleIPs") or []
    ipv4 = next((ip for ip in ips if ":" not in ip), "")
    dns = data.get("Self", {}).get("DNSName", "").rstrip(".")
    peers = sum(1 for peer in (data.get("Peer") or {}).values() if peer.get("Online"))
    print("{}\t{}\t{}\t{}".format(data.get("BackendState", ""), ipv4, dns, peers))
except Exception:
    pass
' 2>/dev/null)"
  IFS=$'\t' read -r STATE IP DNS PEERS <<< "$TS"
  if [ "$STATE" = "Running" ] && [ -n "$IP" ]; then
    sketchybar --set "$NAME" drawing=on icon.color=$GREEN \
               --set dev_network.ip label="IP · $IP" \
               --set dev_network.host label="Host · ${DNS:-Unknown}" \
               --set dev_network.peers label="Online peers · ${PEERS:-0}"
    exit 0
  fi
fi

SERVICE="$(scutil --nc list 2>/dev/null | awk -F '"' '/\(Connected\)/ { print $2; exit }')"
if [ -n "$SERVICE" ]; then
  sketchybar --set "$NAME" drawing=on icon.color=$GREEN \
             --set dev_network.ip label="VPN · $SERVICE" \
             --set dev_network.host label="" \
             --set dev_network.peers label=""
else
  sketchybar --set "$NAME" drawing=off popup.drawing=off
fi
