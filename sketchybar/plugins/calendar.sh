#!/bin/bash
# Timed events within 24h take priority over today's/tomorrow's all-day events.
source "$HOME/.config/sketchybar/colors.sh"
# Python handles dates and Unicode; the shell below renders the selected event.
EVENT="$(python3 - 2>/dev/null <<'PYTHON'
"""Read icalBuddy events and select the next timed or all-day event."""
import datetime as dt
import json
import re
import subprocess
import unicodedata


def select_event(raw, now):
    timed, all_day = [], []
    tomorrow = now.date() + dt.timedelta(days=1)
    for record in raw.split('\x1e'):
        if '\x1f' not in record:
            continue
        dates, title = record.split('\x1f', 1)
        title = ' '.join(title.split())
        current_date, instants, days = None, [], []
        for token in re.finditer(r'D(\d{4}-\d{2}-\d{2})|T(\d{2}:\d{2}:\d{2}[+-]\d{4})', dates):
            if token[1]:
                current_date = token[1]
                days.append(dt.date.fromisoformat(current_date))
            elif current_date:
                instants.append(dt.datetime.strptime(current_date + ' ' + token[2], '%Y-%m-%d %H:%M:%S%z'))
        if not title or not days:
            continue
        if instants:
            start = instants[0]
            end = instants[-1]
            if end < start:  # icalBuddy may omit the end date across midnight.
                end += dt.timedelta(days=1)
            if start <= now < end:
                minutes = max(1, int((end - now).total_seconds() / 60))
                timed.append((0, end, title, f'Now · {minutes}m left', 'ongoing'))
            elif now <= start <= now + dt.timedelta(hours=24):
                minutes = max(1, int((start - now).total_seconds() / 60))
                if start.date() == now.date():
                    remaining = f'{minutes}m' if minutes < 60 else f'{minutes // 60}h {minutes % 60}m'
                    detail = f'{start:%H:%M} · in {remaining}'
                else:
                    detail = f'Tomorrow {start:%H:%M}'
                timed.append((1, start, title, detail, 'soon' if minutes <= 15 else 'normal'))
        else:
            # icalBuddy displays the last occupied date for multi-day all-day events.
            if days[0] <= now.date() <= days[-1]:
                all_day.append((0, title, 'Today · All Day'))
            elif days[0] <= tomorrow <= days[-1]:
                all_day.append((1, title, 'Tomorrow · All Day'))
    if timed:
        _, _, title, detail, state = min(timed)
        return dict(title=title, detail=detail, state=state)
    if all_day:
        _, title, detail = min(all_day)
        return dict(title=title, detail=detail, state='normal')
    return None


def compact_title(title, limit=18):
    def width(char):
        if unicodedata.combining(char):
            return 0
        return 2 if unicodedata.east_asian_width(char) in ('W', 'F') else 1
    if sum(map(width, title)) <= limit:
        return title
    text, used = '', 0
    for char in title:
        if used + width(char) > limit - 1:
            break
        text += char
        used += width(char)
    return text + '…'


def main():
    now = dt.datetime.now().astimezone()
    start = now.strftime('%Y-%m-%d 00:00:00')
    end = (now.date() + dt.timedelta(days=2)).strftime('%Y-%m-%d 00:00:00')
    result = subprocess.run([
        'icalBuddy', '-nc', '-npn', '-nrd', '-iep', 'datetime,title',
        '-po', 'datetime,title', '-tf', 'T%H:%M:%S%z', '-df', 'D%Y-%m-%d',
        '-ps', '|\x1f|', '-b', '\x1e', f'eventsFrom:{start}', f'to:{end}',
    ], capture_output=True, text=True, timeout=15, check=True)
    event = select_event(result.stdout, now)
    if event:
        event['display_title'] = compact_title(event['title'])
    print(json.dumps(event, ensure_ascii=False))


if __name__ == '__main__':
    main()
PYTHON
)" || exit 0
if ! printf '%s' "$EVENT" | jq -e 'type == "object"' >/dev/null 2>&1; then
  sketchybar --set '/upcoming\..*/' drawing=off --set upcoming_group drawing=off
  exit 0
fi
TITLE="$(printf '%s' "$EVENT" | jq -r '.display_title // .title')"
DETAIL="$(printf '%s' "$EVENT" | jq -r '.detail')"
STATE="$(printf '%s' "$EVENT" | jq -r '.state')"
case "$STATE" in
  ongoing) COLOR=$GREEN ;;
  soon) COLOR=$YELLOW ;;
  *) COLOR=$FROST1 ;;
esac
sketchybar --set upcoming.title label="$TITLE" \
           --set upcoming.detail label="$DETAIL" label.color="$COLOR" \
           --set upcoming.icon icon.color="$COLOR" \
           --set '/upcoming\..*/' drawing=on --set upcoming_group drawing=on
