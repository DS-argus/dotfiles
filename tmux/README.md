```text
# tmux quick reference
# config file: ~/.tmux.conf -> ~/.config/tmux/.tmux.conf
# terminal: xterm-256color / RGB override
# history-limit: 100000
# focus-events: on
# plugins: vim-tmux-navigator, tmux-resurrect, tmux-powerkit

# prefix
# Ctrl-Space                 : tmux prefix
# Prefix r                   : config reload
# Prefix C-r                 : tmux-resurrect restore

# windows / panes
# Prefix c                   : new window (current pane path)
# Prefix 1..9                : window jump
# Prefix n / p               : next / previous window
# Prefix q                   : show pane numbers
# Prefix s                   : session tree
# Prefix w                   : window tree
# Prefix |                   : split right
# Prefix -                   : split down
# Prefix m                   : zoom current pane toggle
# Prefix h / j / k / l       : resize pane left / down / up / right

# pane movement
# Ctrl-h / j / k / l         : move between vim and tmux panes
# Ctrl-\                     : move to last pane

# copy mode
# Prefix [                   : enter copy-mode
# q                          : exit copy-mode
# g / G                      : top / bottom
# Ctrl-u / Ctrl-d            : half-page up / down
# / / ?                      : search forward / backward
# n / N                      : next / previous match
# Space or v                 : begin selection
# y or Enter                 : copy

# powerkit
# Prefix T                   : theme selector
# Prefix C-d                 : clear powerkit cache
# Prefix C-e                 : powerkit options
# Prefix C-y                 : powerkit keybindings

# current powerkit display
# datetime format            : %Y-%m-%d %H:%M
# weather location           : Seoul, South Korea
# weather format             : %l: %t %c

# useful defaults worth remembering
# Prefix z                   : zoom toggle (tmux default, same effect as Prefix m here)
# Prefix ;                   : last pane
# Prefix o                   : next pane
# Prefix x                   : kill pane
# Prefix ,                   : rename window
# Prefix :                   : command prompt
```
