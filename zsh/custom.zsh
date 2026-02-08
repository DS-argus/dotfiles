#  Starship : brew install starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

# zoxide - a better cd command : brew install zoxide
eval "$(zoxide init zsh)"

# Yazi : brew install yazi
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

# Ghostty : Shell Integration
# Ghostty shell integration (for tmux panes too)
if [[ -n "${GHOSTTY_RESOURCES_DIR}" ]]; then
  source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
fi


# # pygraphviz
# export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"
