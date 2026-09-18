#!/bin/bash
# CodexBar의 기존 메뉴바 팝오버를 연다.
osascript <<'APPLESCRIPT'
tell application "System Events"
  if not (exists process "CodexBar") then
    tell application "CodexBar" to activate
    delay 0.5
  end if

  tell process "CodexBar"
    repeat with currentBar in menu bars
      repeat with currentItem in menu bar items of currentBar
        try
          if description of currentItem is "status menu" then
            click currentItem
            return
          end if
        end try
      end repeat
    end repeat
  end tell
end tell
APPLESCRIPT
