# =============================================================================
# .zprofile - Login Shell Configuration (로그인 셸에서만 실행)
# =============================================================================
# 이 파일은 로그인 셸에서만 실행됩니다.
# PATH 초기화나 패키지 매니저 환경 설정처럼 로그인 시 1번이면 충분한 내용만 둡니다.

# -----------------------------------------------------------------------------
# Homebrew Environment
# -----------------------------------------------------------------------------
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# -----------------------------------------------------------------------------
# Desktop App CLIs
# -----------------------------------------------------------------------------
export OBSIDIAN_APP_DIR="${OBSIDIAN_APP_DIR:-/Applications/Obsidian.app}"
if [[ -d "${OBSIDIAN_APP_DIR}/Contents/MacOS" ]]; then
  export PATH="${PATH}:${OBSIDIAN_APP_DIR}/Contents/MacOS"
fi

# # -----------------------------------------------------------------------------
# # Homebrew Formula PATH
# # -----------------------------------------------------------------------------
# if [[ -n "${HOMEBREW_PREFIX:-}" && -d "${HOMEBREW_PREFIX}/opt/postgresql@16/bin" ]]; then
#   export PATH="${HOMEBREW_PREFIX}/opt/postgresql@16/bin:${PATH}"
# fi
