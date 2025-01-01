# aliases for configuration
alias reload-zshrc="source ~/.zshrc"
alias edit-zshrc="nvim ~/.zshrc"
alias edit-alias="nvim ~/.config/zsh/aliases.zsh"
alias edit-custom="nvim ~/.config/zsh/custom.zsh"
alias edit-starship="nvim ~/.config/starship/starship.toml"
alias edit-obsidian-vimrc="nvim ~/Desktop/Obsidian/Argus/.obsidian.vimrc"

# aliases for eza
alias ls="eza --icons=always"
alias ll="eza -lah --icons=always"
alias la="eza -a --icons=always"
alias lt="eza -aT -L1 --color=always --group-directories-first --icons"
alias lt2="eza -aT -L2 --color=always --group-directories-first --icons"
alias lt3="eza -aT -L3 --color=always --group-directories-first --icons"

# aliases for Zoxide
alias cd="z"

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

# other aliases
alias c="clear"
alias e="exit"
alias DO="viu /Users/argus/Desktop/Docalculus.png"


