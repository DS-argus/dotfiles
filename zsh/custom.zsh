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

# pygrahpviz
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"

# zxoxide - a better cd dommand
eval "$(zoxide init zsh)"
