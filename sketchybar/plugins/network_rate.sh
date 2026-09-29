#!/bin/bash
# Default-route interface throughput; one sampler updates both display rows.
source "$HOME/.config/sketchybar/colors.sh"

umask 077
STATE_DIR="/tmp/sketchybar-network-${UID}"
mkdir -m 700 "$STATE_DIR" 2>/dev/null
# Never follow a directory supplied by another user or a symbolic link.
[[ -d "$STATE_DIR" && -O "$STATE_DIR" && ! -L "$STATE_DIR" ]] || exit 0
STATE="$STATE_DIR/rate"

INTERFACE="$(route -n get default 2>/dev/null | awk '/interface:/ { print $2; exit }')"
COUNTERS="$(netstat -ibn 2>/dev/null | awk -v iface="$INTERFACE" '
  $1 == iface && $3 ~ /^<Link#/ { print $(NF - 4), $(NF - 1); exit }
')"
read -r RECEIVED SENT <<< "$COUNTERS"
if [[ -z "$INTERFACE" || ! "$RECEIVED" =~ ^[0-9]+$ || ! "$SENT" =~ ^[0-9]+$ ]]; then
  rm -f "$STATE"
  sketchybar --set network.up label="—" label.color="$MUTED" icon.color="$MUTED" \
             --set network.down label="—" label.color="$MUTED" icon.color="$MUTED"
  exit 0
fi

NOW="$(date +%s)"
OLD_INTERFACE= OLD_TIME=0 OLD_RECEIVED=0 OLD_SENT=0
if [[ -f "$STATE" && ! -L "$STATE" ]]; then
  read -r OLD_INTERFACE OLD_TIME OLD_RECEIVED OLD_SENT < "$STATE"
fi

# Atomic replacement keeps readers from seeing a partial sample.
TEMP="$(mktemp "$STATE_DIR/sample.XXXXXX")" || exit 0
printf '%s %s %s %s\n' "$INTERFACE" "$NOW" "$RECEIVED" "$SENT" > "$TEMP"
mv -f "$TEMP" "$STATE"

RATES="$(awk -v iface="$INTERFACE" -v old_iface="$OLD_INTERFACE" \
  -v now="$NOW" -v before="$OLD_TIME" \
  -v received="$RECEIVED" -v old_received="$OLD_RECEIVED" \
  -v sent="$SENT" -v old_sent="$OLD_SENT" '
  function rate(bytes) {
    if (bytes >= 1048576) return sprintf("%.1f MB/s", bytes / 1048576)
    if (bytes >= 1024) return sprintf("%.0f KB/s", bytes / 1024)
    return sprintf("%.0f B/s", bytes)
  }
  BEGIN {
    upload = download = 0
    elapsed = now - before
    if (iface == old_iface && elapsed > 0 && elapsed < 120 &&
        received >= old_received && sent >= old_sent) {
      upload = (sent - old_sent) / elapsed
      download = (received - old_received) / elapsed
    }
    print rate(upload)
    print rate(download)
  }
')"
UPLOAD="${RATES%%$'\n'*}"
DOWNLOAD="${RATES#*$'\n'}"
sketchybar --set network.up label="$UPLOAD" label.color="$PURPLE" icon.color="$PURPLE" \
           --set network.down label="$DOWNLOAD" label.color="$FROST1" icon.color="$FROST1"
