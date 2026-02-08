# Neovim Configuration

Lazy.nvim 기반의 Neovim 설정. Python 개발 환경에 최적화되어 있습니다.

## 구조

```
~/.config/nvim/
├── init.lua                 # 진입점
├── lua/psm/
│   ├── core/
│   │   ├── options.lua      # 기본 옵션
│   │   └── keymaps.lua      # 전역 키맵
│   ├── lazy.lua             # 플러그인 매니저
│   └── plugins/             # 플러그인 설정
│       ├── lsp/
│       │   ├── lspconfig.lua
│       │   └── mason.lua
│       └── ...
```

---

## Python 개발 환경

### LSP: Pyright

타입 체크, 자동완성, Go to Definition 제공.

| 설정 | 값 | 설명 |
|------|-----|------|
| `typeCheckingMode` | `off` | 타입 체크 비활성화 (속도 향상) |
| `diagnosticMode` | `openFilesOnly` | 열린 파일만 분석 |
| `autoSearchPaths` | `false` | 경로 자동 탐색 비활성화 |
| `exclude` | `venv, .venv, __pycache__` | 분석 제외 경로 |

### 포맷터 & 린터: Ruff

black, isort, pylint를 **Ruff 하나로 통합**.

| 도구 | 역할 |
|------|------|
| `ruff_format` | 코드 포맷팅 (black 대체) |
| `ruff_organize_imports` | import 정리 (isort 대체) |
| `ruff` (lint) | 스타일 린팅 (pylint 대체) |

### 성능 최적화

```lua
-- Python provider 비활성화 (시작 속도 향상)
vim.g.loaded_python3_provider = 0
```

---

## 플러그인 목록

### LSP & 자동완성

| 플러그인 | 기능 |
|---------|------|
| `nvim-lspconfig` | LSP 클라이언트 설정 |
| `mason.nvim` | LSP/도구 설치 관리 |
| `nvim-cmp` | 자동완성 엔진 |
| `LuaSnip` | 스니펫 엔진 |

### 코드 품질

| 플러그인 | 기능 |
|---------|------|
| `conform.nvim` | 포맷터 (저장 시 자동 포맷) |
| `nvim-lint` | 린터 |
| `nvim-treesitter` | 구문 하이라이팅, 인덴트 |
| `nvim-ufo` | 코드 폴딩 (treesitter 기반) |

### 탐색 & UI

| 플러그인 | 기능 |
|---------|------|
| `telescope.nvim` | 퍼지 파인더 |
| `nvim-tree.lua` | 파일 탐색기 |
| `bufferline.nvim` | 탭/버퍼 라인 |
| `lualine.nvim` | 상태 표시줄 |
| `tokyonight.nvim` | 컬러스킴 |

### 편집 지원

| 플러그인 | 기능 |
|---------|------|
| `nvim-autopairs` | 자동 괄호 닫기 |
| `nvim-surround` | surround 편집 |
| `Comment.nvim` | 주석 토글 |
| `substitute.nvim` | 텍스트 치환 |

### 기타

| 플러그인 | 기능 |
|---------|------|
| `which-key.nvim` | 키맵 힌트 표시 |
| `trouble.nvim` | 진단 목록 |
| `todo-comments.nvim` | TODO 하이라이트 |
| `noice.nvim` | UI 개선 (메시지, cmdline) |

---

## 주요 키맵

Leader 키: `Space`

### 일반

| 키 | 동작 |
|----|------|
| `jk` | Insert 모드 탈출 |
| `<leader>nh` | 검색 하이라이트 제거 |

### 파일 탐색

| 키 | 동작 |
|----|------|
| `<leader>ee` | 파일 탐색기 토글 |
| `<leader>ef` | 현재 파일 위치에서 탐색기 열기 |
| `<leader>ff` | 파일 찾기 |
| `<leader>fs` | 텍스트 검색 (live grep) |
| `<leader>fr` | 최근 파일 |

### 코드

| 키 | 동작 |
|----|------|
| `<leader>mp` | 수동 포맷팅 |
| `<leader>l` | 수동 린팅 |
| `<leader>lt` | 린팅 토글 on/off |

### 진단

| 키 | 동작 |
|----|------|
| `<leader>xx` | Trouble 토글 |
| `<leader>xd` | 문서 진단 |
| `<leader>xw` | 워크스페이스 진단 |

### 창 관리

| 키 | 동작 |
|----|------|
| `<leader>sv` | 수직 분할 |
| `<leader>sh` | 수평 분할 |
| `<leader>sx` | 현재 창 닫기 |
| `<leader>sm` | 창 최대화 토글 |

### 탭

| 키 | 동작 |
|----|------|
| `Tab` | 다음 탭 |
| `Shift+Tab` | 이전 탭 |
| `<leader>to` | 새 탭 |
| `<leader>tx` | 탭 닫기 |

---

## 설치된 도구 (Mason)

### LSP 서버

- `pyright` - Python
- `lua_ls` - Lua
- `rust_analyzer` - Rust

### 포맷터 & 린터

- `ruff` - Python (lint + format)
- `stylua` - Lua
- `prettier` - HTML/CSS/JSON/YAML/Markdown

---

## 설치

```bash
# 1. 저장소 클론
git clone <repo> ~/.config/nvim

# 2. Neovim 실행 (플러그인 자동 설치)
nvim

# 3. Mason으로 도구 설치
:MasonInstall ruff pyright stylua prettier
```
