# =============================================================================
# .zshrc - Interactive Shell Configuration (인터랙티브 셸에서만 실행)
# =============================================================================
# 이 파일은 사용자가 직접 상호작용하는 터미널 세션에서만 실행됩니다.
# 플러그인, 별칭, 키바인딩 등 사용자 경험을 위한 설정들을 포함합니다.

# -----------------------------------------------------------------------------
# History Configuration (히스토리 설정)
# -----------------------------------------------------------------------------
HISTFILE=$HOME/.zhistory         # 히스토리 파일 위치
SAVEHIST=1000                    # 히스토리 파일에 저장할 명령어 수
HISTSIZE=999                     # 메모리에 보관할 히스토리 수
setopt share_history             # 모든 세션 간 히스토리 공유
setopt hist_expire_dups_first    # 중복 항목을 먼저 만료
setopt hist_ignore_dups          # 연속된 중복 명령어 무시
setopt hist_verify               # 히스토리 확장 시 확인 프롬프트
setopt HIST_IGNORE_ALL_DUPS      # 모든 중복 명령어 무시

# -----------------------------------------------------------------------------
# Custom Configuration Files (사용자 정의 설정 파일들)
# -----------------------------------------------------------------------------
# 사용자 정의 zsh 설정
[ -f "$HOME/.config/zsh/custom.zsh" ] && source "$HOME/.config/zsh/custom.zsh"

# 별칭(aliases) 설정
[ -f "$HOME/.config/zsh/aliases.zsh" ] && source "$HOME/.config/zsh/aliases.zsh"

# 개인적인 설정 (민감한 정보 포함 가능)
[ -f "$HOME/.config/zsh/privates.zsh" ] && source "$HOME/.config/zsh/privates.zsh"

# -----------------------------------------------------------------------------
# Zsh Plugins (zsh 플러그인들)
# 설치 필요: brew install zsh-syntax-highlighting zsh-autosuggestions zsh-completions
# -----------------------------------------------------------------------------
# 문법 강조 플러그인 : 입력한 명령어의 문법을 색상으로 구분
# https://github.com/zsh-users/zsh-syntax-highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# 자동 제안 플러그인 : 이전에 입력한 명령을 자동으로 회색 글씨로 예측
# https://github.com/zsh-users/zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# 자동 완성 플러그인 : 기본 zsh 패키지에 포함되지 않은 외부 프로그램들에 대한 completion 스크립트를 추가로 제공
# https://github.com/zsh-users/zsh-completions
FPATH=$(brew --prefix)/share/zsh-completions:$FPATH && autoload -Uz compinit && compinit

# -----------------------------------------------------------------------------
# Key Bindings (키 바인딩 설정)
# -----------------------------------------------------------------------------
# Tab과 Shift+Tab으로 zsh-completions 순환
bindkey '^I' menu-complete                    # Tab 키
bindkey "$terminfo[kcbt]" reverse-menu-complete  # Shift+Tab 키

# Ctrl+O로 autosuggestion 수락 : 원래는 오른쪽 방향키
bindkey '^O' autosuggest-accept

# -----------------------------------------------------------------------------
# Terminal Integration (터미널 통합)
# -----------------------------------------------------------------------------
# Kiro 터미널 통합 (해당 터미널 사용 시에만)
[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# Added by Antigravity
export PATH="/Users/argus/.antigravity/antigravity/bin:$PATH"
