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

# aliaes for rust
alias cn="cargo new"
alias cr="cargo run"

# aliaes for docker
alias dkn='docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}"'     # 실행 중인 컨테이너 목록 출력 (ID, Image, Names, Status)
alias dkna='docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}"' # 모든 컨테이너 dkn처럼 출력
alias dkp='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Ports}}"'      # 실행 중인 컨테이너 포트 정보 포함 출력
alias dks='docker ps -s --format "table {{.Names}}\t{{.Size}}"'                         # 실행 중인 컨테이너 디스크 사용량 출력
alias dkQuartz='docker run --rm -itp 8080:8080 -p 3001:3001 -v ./content:/usr/src/app/content $(docker build -q .)'
alias dkrmAll='docker rm -f $(docker ps -aq)'

# other aliases
alias c="clear"
alias e="exit"


