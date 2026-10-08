#!/usr/bin/env bash
# Pick any pane on this tmux server and view it live inside the current popup.
# Usage: peek-pane.sh <origin-window-id>   (panes of that window are hidden)
set -euo pipefail

origin_window=${1:-}

# Column widths. tmux p/= modifiers are display-width aware (CJK safe); a
# truncation marker adds one cell, so truncate to width-1.
w_session=14 w_target=4 w_cmd=8 w_path=24

c() { printf '\033[38;2;%sm' "$1"; }
reset=$'\033[0m'
session_c=$(c '136;192;208') # nord8
target_c=$(c '97;110;136')   # nord3 (bright)
cmd_c=$(c '163;190;140')     # nord14
path_c=$(c '129;161;193')    # nord9
fallback_c=$(c '97;110;136')

# Shell panes usually title themselves with the cwd or the host name; those
# duplicate the PATH column, so fall back to a manually set window name.
title="#{?#{||:#{m/r:^(~|…|/|$),#{pane_title}},#{==:#{pane_title},#{host}}},#{?automatic-rename,,${fallback_c}#{window_name}${reset}},#{pane_title}}"

row="${session_c}#{p${w_session}:#{=/$((w_session - 1))/…:session_name}}${reset} "
row+="${target_c}#{p${w_target}:#{window_index}.#{pane_index}}${reset} "
row+="${cmd_c}#{p${w_cmd}:#{=/$((w_cmd - 1))/…:pane_current_command}}${reset} "
row+="${path_c}#{p${w_path}:#{=/-$((w_path - 1))/…:#{s|^${HOME}|~|:pane_current_path}}}${reset} "
row+="$title"

header=$(printf "%-${w_session}s %-${w_target}s %-${w_cmd}s %-${w_path}s %s" \
  SESSION W.P CMD PATH 'TITLE / WINDOW')

# capture-pane emits the full pane height; drop trailing blank lines so the
# preview's follow mode lands on the last real output.
preview="tmux capture-pane -ep -t {1} | awk '{l[NR]=\$0} NF{n=NR} END{for(i=1;i<=n;i++)print l[i]}'"

# Nord palette, matching the tmux popup border (nord3) and title pill (nord8).
colors='border:#4c566a,label:#88c0d0:bold,header:#4c566a,info:#4c566a'
colors+=',prompt:#88c0d0,pointer:#88c0d0,hl:#ebcb8b,hl+:#ebcb8b'
colors+=',current-bg:#3b4252,gutter:-1,scrollbar:#4c566a,separator:#4c566a'

# Fields after the sort key is stripped:
#   1 pane_id  2 session_id  3 window_id  4 visible row  5 preview label
# Most recently peeked panes first (@peek_last is stamped below); never-peeked
# panes keep tmux order thanks to the stable sort. Grouped sessions list the
# same pane more than once, so dedupe by pane id after sorting.
pick=$(
  tmux list-panes -a \
    -f "#{&&:#{!=:#{window_id},$origin_window},#{?#{m:peek-*,#{session_name}},0,1}}" \
    -F "#{?@peek_last,#{@peek_last},0}	#{pane_id}	#{session_id}	#{window_id}	$row	#{session_name}:#{window_index}.#{pane_index}" |
    sort -t "$(printf '\t')" -k1,1nr -s |
    awk -F '\t' '!seen[$2]++ { sub(/^[^\t]*\t/, ""); print }' |
    fzf --ansi --delimiter='\t' --with-nth=4 --reverse --tiebreak=index \
      --input-border=bold --list-border=bold --preview-border=bold \
      --header-border=inline --header="$header" \
      --prompt='  ' --pointer='▌' --info=inline-right \
      --list-label=' panes ' --preview-label=' preview ' \
      --bind 'focus:transform-preview-label:echo " {r5} "' \
      --color="$colors" \
      --preview "$preview" \
      --preview-window='right,45%,follow,<60(down,55%,follow)'
) || exit 0

IFS=$'\t' read -r pane session window _ <<<"$pick"

# Keep the normal status line (prefix/copy-mode indicators) but show the peeked
# session's name instead of the throwaway peek-<pid> name.
status_left=$(tmux show-options -gv status-left)
status_left=${status_left//'#S'/'#{session_group}'}
status_left=${status_left//'#{session_name}'/'#{session_group}'}

# Grouped session: shares the target session's windows but keeps its own current
# window, so clients of the target session are not switched. Created attached so
# destroy-unattached removes it as soon as the popup goes away (Esc, detach, -C).
exec tmux new-session -s "peek-$$" -t "$session" \; \
  set-option status-left "$status_left" \; \
  set-option destroy-unattached on \; \
  select-window -t "$window" \; \
  select-pane -t "$pane" \; \
  set-option -p -t "$pane" @peek_last "$(date +%s)"
