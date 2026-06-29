#!/usr/bin/env bash
# PowerKit custom theme: Nord with stronger statusline contrast for transparent cells.

declare -gA THEME_COLORS=(
    [background]="#2e3440"

    [statusbar-bg]="#2e3440"
    [statusbar-fg]="#eceff4"

    [session-bg]="#5e81ac"
    [session-fg]="#eceff4"
    [session-prefix-bg]="#d08770"
    [session-copy-bg]="#81a1c1"
    [session-search-bg]="#ebcb8b"
    [session-command-bg]="#b48ead"

    [window-active-base]="#5e81ac"
    [window-active-style]="bold"

    [window-inactive-base]="#3b4252"
    [window-inactive-style]="none"

    [window-activity-style]="italics"
    [window-bell-style]="bold"
    [window-zoomed-bg]="#88c0d0"

    [pane-border-active]="#88c0d0"
    [pane-border-inactive]="#4c566a"

    [ok-base]="#3b4252"
    [good-base]="#a3be8c"
    [info-base]="#5e81ac"
    [warning-base]="#ebcb8b"
    [error-base]="#bf616a"
    [disabled-base]="#434c5e"

    [message-bg]="#3b4252"
    [message-fg]="#eceff4"

    [popup-bg]="default"
    [popup-fg]="#eceff4"
    [popup-border]="#88c0d0"
    [menu-bg]="default"
    [menu-fg]="#eceff4"
    [menu-selected-bg]="#5e81ac"
    [menu-selected-fg]="#eceff4"
    [menu-border]="#88c0d0"
)
