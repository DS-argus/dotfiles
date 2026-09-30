#!/bin/bash
# 활동 모니터의 "사용된 메모리"(앱 + 와이어드 + 압축)를 표시하고, 색은 커널 메모리 압박 단계를 따른다
source "$HOME/.config/sketchybar/colors.sh"

TOTAL_BYTES="$(sysctl -n hw.memsize 2>/dev/null)"
USED="$(vm_stat 2>/dev/null | awk -v total="$TOTAL_BYTES" '
  /page size of/ { for (i = 1; i <= NF; i++) if ($i == "of") page = $(i + 1) }
  /^Anonymous pages:/ { anon = $3 }
  /^Pages purgeable:/ { purgeable = $3 }
  /^Pages wired down:/ { wired = $4 }
  /^Pages occupied by compressor:/ { compressed = $5 }
  END {
    if (page == 0 || total == 0) exit
    used = int((anon - purgeable + wired + compressed) * page / total * 100 + 0.5)
    if (used > 100) used = 100
    print used
  }')"
[ -z "$USED" ] && exit 0
POINT="$(awk -v used="$USED" 'BEGIN { printf "%.2f", used / 100 }')"

# kern.memorystatus_vm_pressure_level: 1 정상, 2 경고, 4 위험
case "$(sysctl -n kern.memorystatus_vm_pressure_level 2>/dev/null)" in
  4)
    COLOR=$RED
    FILL=0x40bf616a
    ;;
  2)
    COLOR=$YELLOW
    FILL=0x40ebcb8b
    ;;
  *)
    COLOR=$PURPLE
    FILL=0x40b48ead
    ;;
esac

sketchybar --set "$NAME" icon.color=$COLOR label="RAM ${USED}%" \
           --set memory_graph graph.color=$COLOR graph.fill_color=$FILL \
           --push memory_graph "$POINT"
