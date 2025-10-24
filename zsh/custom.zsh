# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

#  Starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"
starship config palette $STARSHIP_THEME

# zoxide - a better cd command
eval "$(zoxide init zsh)"

# Yazi
export EDITOR="nvim"
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# PostgreSQL@16
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

# # pygraphviz
# export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"