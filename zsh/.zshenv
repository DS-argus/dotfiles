# =============================================================================
# .zshenv - Environment Variables (모든 zsh 세션에서 실행)
# =============================================================================
# 이 파일은 모든 zsh 세션(로그인/비로그인, 인터랙티브/비인터랙티브)에서 실행됩니다.
# 환경 변수와 기본 시스템 설정만 포함해야 합니다.

# -----------------------------------------------------------------------------
# Locale Settings (언어 및 지역 설정)
# -----------------------------------------------------------------------------
export LANG="en_US.UTF-8"        # 모든 카테고리의 기본 로케일 설정

# -----------------------------------------------------------------------------
# Base Directories & Shared Environment
# -----------------------------------------------------------------------------
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export ZDOTDIR="${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}"
export CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"
export EDITOR="${EDITOR:-nvim}"
export OBSIDIAN_VAULT_DIR="${OBSIDIAN_VAULT_DIR:-$HOME/Desktop/Obsidian/Argus}"

# -----------------------------------------------------------------------------
# Development Environment (개발 환경 설정)
# -----------------------------------------------------------------------------
# PATH와 연결된 배열에서 첫 번째 경로만 유지
typeset -U path PATH

# Rust 개발 환경 초기화
[ -f "$CARGO_HOME/env" ] && . "$CARGO_HOME/env"

# 로컬 실행 파일 (uv 등): 비로그인 셸에서도 우선 사용
path=("$HOME/.local/bin" $path)
