# zsh Options
setopt HIST_IGNORE_ALL_DUPS

# Custom zsh
[ -f "$HOME/.config/zsh/custom.zsh" ] && source "$HOME/.config/zsh/custom.zsh"

# Aliases
[ -f "$HOME/.config/zsh/aliases.zsh" ] && source "$HOME/.config/zsh/aliases.zsh"

# Private
[ -f "$HOME/.config/zsh/privates.zsh" ] && source "$HOME/.config/zsh/privates.zsh"

# Plugins
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
FPATH=$(brew --prefix)/share/zsh-completions:$FPATH && autoload -Uz compinit && compinit

# bindkeys
# Make Tab and ShiftTab cycle completions on the command line
bindkey              '^I'         menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete

# ctrl+O로 autosuggest complete
bindkey '^O' autosuggest-accept
