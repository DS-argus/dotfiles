# Neovim Configuration

Lazy.nvim 기반의 개인 Neovim 설정입니다.

현재 구성은 Python, Lua, Go, Rust 개발을 중심으로 LSP, 포맷팅, lint, 파일 검색, markdown 작성, 진단 탐색을 가볍게 묶는 방향입니다.

## 구조

```text
~/.config/nvim/
├── init.lua
├── lazy-lock.json
└── lua/psm/
    ├── lazy.lua
    ├── core/
    │   ├── init.lua
    │   ├── options.lua
    │   ├── keymaps.lua
    │   └── treesitter.lua
    ├── lsp/
    │   ├── init.lua
    │   ├── servers.lua
    │   ├── keymaps.lua
    │   ├── pyright.lua
    │   ├── lua_ls.lua
    │   └── gopls.lua
    └── plugins/
        ├── lsp/
        │   ├── mason.lua
        │   └── lspconfig.lua
        └── *.lua
```

## 기본 정책

- Leader: `Space`
- LocalLeader: `,`
- 들여쓰기: `tabstop=2`, `shiftwidth=2`, `expandtab=true`
- 줄 번호: absolute + relative number
- 검색: `ignorecase` + `smartcase`
- split: 세로 split은 오른쪽, 가로 split은 아래쪽
- 파일 변경 감지: focus, buffer enter, cursor hold, terminal leave/close 시 `checktime`
- Python provider 비활성화: 현재 Python provider를 쓰는 플러그인이 없어 시작 시간을 줄임
- 기본 파일 탐색: `netrw` tree style 유지, `snacks.explorer`는 비활성화

## 언어 지원

### LSP

| 서버            | 용도   | 커스텀 설정                                                                                  |
| --------------- | ------ | -------------------------------------------------------------------------------------------- |
| `pyright`       | Python | 프로젝트 root marker 지정, `.venv`/`VIRTUAL_ENV`/시스템 Python 순서로 `pythonPath` 자동 설정 |
| `lua_ls`        | Lua    | `vim` global 허용, Neovim runtime library 등록                                               |
| `gopls`         | Go     | `staticcheck=true`, `go/gomod/gowork` filetype                                               |
| `rust_analyzer` | Rust   | 기본 설정 사용                                                                               |

LSP attach 시 공통 키맵과 진단 아이콘을 설정합니다. 서버별 후처리는 `psm.lsp.servers`에서 각 모듈의 `on_attach`로 위임합니다.

### 포맷팅

`conform.nvim`이 저장 시 포맷을 수행합니다. 수동 포맷은 `<leader>mf`입니다.

| Filetype                    | Formatter                              |
| --------------------------- | -------------------------------------- |
| Python                      | `ruff_organize_imports`, `ruff_format` |
| Lua                         | `stylua`                               |
| Go                          | `goimports`, `gofmt`                   |
| Rust                        | `rustfmt`, LSP fallback                |
| CSS/HTML/JSON/YAML/Markdown | `prettier`                             |

### Lint

`nvim-lint`는 기본적으로 Python에 `ruff`를 연결합니다. lint는 자동 상시 실행이 아니라 토글/수동 실행 중심입니다.

## 플러그인

### Core

| 플러그인             | 기능                                   |
| -------------------- | -------------------------------------- |
| `lazy.nvim`          | 플러그인 매니저                        |
| `plenary.nvim`       | 여러 플러그인의 Lua utility dependency |
| `vim-tmux-navigator` | tmux pane과 Neovim split 이동 연동     |

### LSP, Completion

| 플러그인                    | 기능                             |
| --------------------------- | -------------------------------- |
| `nvim-lspconfig`            | Neovim LSP 서버 설정             |
| `mason.nvim`                | LSP 서버와 CLI 도구 관리 UI      |
| `mason-lspconfig.nvim`      | Mason과 LSP 서버 이름 연결       |
| `mason-tool-installer.nvim` | formatter/linter 도구 관리       |
| `cmp-nvim-lsp`              | LSP completion capability        |
| `nvim-cmp`                  | completion engine                |
| `cmp-buffer`                | 현재 buffer completion source    |
| `cmp-path`                  | path completion source           |
| `LuaSnip`                   | snippet engine                   |
| `cmp_luasnip`               | LuaSnip completion source        |
| `friendly-snippets`         | VS Code style snippet collection |
| `lspkind.nvim`              | completion menu icon formatting  |
| `neodev.nvim`               | Neovim Lua 개발 보조             |
| `nvim-lsp-file-operations`  | 파일 rename/move와 LSP 연동      |

### Formatting, Lint, Syntax

| 플러그인                        | 기능                                            |
| ------------------------------- | ----------------------------------------------- |
| `conform.nvim`                  | 포맷팅 및 저장 시 포맷                          |
| `nvim-lint`                     | lint 실행                                       |
| `nvim-treesitter`               | syntax highlight, indent, incremental selection |
| `nvim-ts-autotag`               | HTML/XML tag 자동 처리                          |
| `nvim-ts-context-commentstring` | JSX/HTML 등 context-aware commentstring         |
| `nvim-colorizer.lua`            | 색상 코드 하이라이트                            |

### Search, Navigation, Diagnostics

| 플러그인             | 기능                                             |
| -------------------- | ------------------------------------------------ |
| `snacks.nvim`        | dashboard, picker, input, indent guide, zen/zoom |
| `grug-far.nvim`      | 현재 파일 중심 찾기/바꾸기 UI                    |
| `trouble.nvim`       | diagnostics, quickfix, loclist, TODO 목록        |
| `todo-comments.nvim` | TODO/FIX/FIXME 등 하이라이트 및 이동             |
| `which-key.nvim`     | keymap hint UI                                   |

### UI

| 플러그인                  | 기능                                               |
| ------------------------- | -------------------------------------------------- |
| `tokyonight.nvim`         | colorscheme                                        |
| `lualine.nvim`            | statusline                                         |
| `noice.nvim`              | command line, message UI                           |
| `nvim-notify`             | notification backend                               |
| `nui.nvim`                | UI dependency                                      |
| `nvim-web-devicons`       | filetype/dev icons                                 |
| `comfy-line-numbers.nvim` | terminal/nofile/prompt buffer에서 line number 숨김 |
| `smear-cursor.nvim`       | cursor smear animation                             |

### Editing

| 플러그인               | 기능                                             |
| ---------------------- | ------------------------------------------------ |
| `nvim-autopairs`       | bracket/quote 자동 닫기, `nvim-cmp` confirm 연동 |
| `nvim-surround`        | `ys`, `ds`, `cs` surround 편집                   |
| `Comment.nvim`         | 주석 토글                                        |
| `render-markdown.nvim` | markdown rendering toggle                        |

## 커스텀 동작

### Snacks File Picker

`<leader>ff`는 `Snacks.picker.files()`를 사용합니다.

- hidden 파일은 기본 포함
- ignored 파일은 기본 제외
- picker 제목에 주요 열기 키를 짧게 표시
- `H`로 hidden 포함 여부 토글
- `I`로 ignored 포함 여부 토글
- `⏎`는 현재 창 열기
- `^T`는 새 Neovim tabpage 열기
- `^S`는 horizontal split 열기
- `^V`는 vertical split 열기

### Neovim Tabpage

Neovim tabpage는 파일 탭이 아니라 window layout 묶음으로 사용합니다. 별도 tabline 플러그인은 쓰지 않고 기본 tabpage 명령을 키맵으로 얹었습니다.

| 키           | 동작              |
| ------------ | ----------------- |
| `<leader>tn` | 다음 tabpage      |
| `<leader>tp` | 이전 tabpage      |
| `<leader>tx` | 현재 tabpage 닫기 |

### Treesitter Fold Guard

기본 fold는 `manual`입니다. 특정 filetype에서 parser가 있을 때만 Treesitter fold expression을 활성화합니다. markdown과 특수 buffer에서 fold 관련 비동기 오류가 나는 것을 피하기 위한 설정입니다.

### Markdown Injection Override

`core/treesitter.lua`에서 markdown `injections` query를 직접 설정합니다. 목적은 Neovim 0.12 runtime query 경로를 기준으로 code fence, HTML block, YAML/TOML metadata, inline markdown injection을 안정적으로 유지하는 것입니다.

### Pyright Python Path

`pyright`는 다음 순서로 Python 실행 파일을 찾습니다.

1. 현재 파일/프로젝트 상위의 `.venv/bin/python`
2. `$VIRTUAL_ENV/bin/python`
3. `python3`
4. `python`

LSP attach 후에도 현재 buffer 위치 기준으로 `pythonPath`를 다시 반영합니다.

### Grug Far

`<leader>sr`은 전체 프로젝트가 아니라 현재 파일 기준 찾기/바꾸기로 열립니다. Normal mode에서는 cursor word를 검색어로 prefill하고, Visual mode에서는 선택 영역을 검색어로 사용합니다. UI가 준비되면 replacement 입력으로 포커스를 옮깁니다.

### Markdown Render

`render-markdown.nvim`은 markdown 파일에서 lazy-load되지만 기본 rendering은 꺼져 있습니다. `<leader>mr`로 buffer 단위 렌더링을 토글합니다.

## 주요 키맵

### General

| 키           | 동작                 |
| ------------ | -------------------- |
| `jk`         | Insert mode 종료     |
| `<leader>nh` | 검색 하이라이트 제거 |
| `<leader>+`  | 숫자 증가            |
| `<leader>-`  | 숫자 감소            |

### Window, Tab, Focus

| 키           | 동작                   |
| ------------ | ---------------------- |
| `<leader>sv` | 세로 split             |
| `<leader>sh` | 가로 split             |
| `<leader>se` | split 크기 균등화      |
| `<leader>sx` | 현재 split 닫기        |
| `<leader>sm` | 현재 split zoom toggle |
| `<leader>sz` | Zen mode toggle        |
| `<leader>tn` | 다음 tabpage           |
| `<leader>tp` | 이전 tabpage           |
| `<leader>tx` | 현재 tabpage 닫기      |

### Find

| 키           | 동작                                         |
| ------------ | -------------------------------------------- |
| `<leader>ff` | 파일 찾기                                    |
| `<leader>fr` | 최근 파일                                    |
| `<leader>fs` | 문자열 검색                                  |
| `<leader>fc` | cursor word 검색                             |
| `<leader>ft` | TODO/FIX/FIXME/HACK/WARN/PERF/NOTE/TEST 검색 |

### LSP

| 키           | 동작          |
| ------------ | ------------- |
| `gd`         | 정의로 이동   |
| `gD`         | 선언으로 이동 |
| `gR`         | 참조 보기     |
| `K`          | hover 문서    |
| `<leader>rn` | rename        |
| `<leader>ca` | code action   |
| `<leader>ld` | 줄 진단 float |
| `<leader>ls` | 문서 symbol   |

### Format, Lint, Replace

| 키           | 동작                  |
| ------------ | --------------------- |
| `<leader>mf` | 파일/선택 영역 포맷   |
| `<leader>lt` | lint 토글             |
| `<leader>ll` | 현재 파일 lint 실행   |
| `<leader>sr` | 현재 파일 찾기/바꾸기 |

### Diagnostics, TODO

| 키           | 동작                  |
| ------------ | --------------------- |
| `<leader>xx` | Trouble 목록 토글     |
| `<leader>xw` | workspace diagnostics |
| `<leader>xd` | document diagnostics  |
| `<leader>xq` | quickfix              |
| `<leader>xl` | loclist               |
| `<leader>xt` | TODO Trouble          |
| `]t`         | 다음 TODO             |
| `[t`         | 이전 TODO             |

### UI

| 키             | 동작                    |
| -------------- | ----------------------- |
| `<leader>?`    | 현재 buffer keymap 보기 |
| `<C-w><space>` | window keymap 보기      |
| `<leader>nd`   | Noice message dismiss   |

## Mason 관리 대상

### LSP Servers

- `pyright`
- `lua_ls`
- `rust_analyzer`
- `gopls`

### Tools

- `ruff`
- `stylua`
- `prettier`
- `goimports`
