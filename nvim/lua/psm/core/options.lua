-- 기본 파일 탐색기(netrw)
vim.g.netrw_liststyle = 3 -- 트리 스타일로 표시

-- Python provider 비활성화 (사용하는 플러그인 없음, 시작 속도 향상)
vim.g.loaded_python3_provider = 0

local opt = vim.opt

-- 줄 번호
opt.number = true -- 현재 줄 번호 표시
opt.relativenumber = true -- 현재 줄 기준 상대 줄 번호 표시

-- 들여쓰기
opt.tabstop = 2 -- 탭 문자 하나를 화면에서 2칸으로 표시
opt.shiftwidth = 2 -- 자동 들여쓰기와 <<, >> 이동 폭을 2칸으로 설정
opt.expandtab = true -- 탭 입력을 스페이스로 변환
opt.autoindent = true -- 새 줄을 만들 때 현재 줄의 들여쓰기 유지

-- 검색
opt.ignorecase = true -- 검색할 때 대소문자 무시
opt.smartcase = true -- 검색어에 대문자가 있으면 대소문자를 구분

-- 화면 표시
opt.wrap = false -- 긴 줄을 자동 줄바꿈하지 않음
opt.cursorline = true -- 현재 커서가 있는 줄 강조
opt.termguicolors = true -- 터미널 true color 사용
opt.background = "dark" -- 다크 배경 기준으로 컬러스킴 적용
opt.signcolumn = "yes" -- 진단/깃 표시 영역을 항상 보여 텍스트 밀림 방지

-- 코드 접기
opt.foldmethod = "manual" -- 특수 버퍼와 markdown에서 Treesitter fold 비동기 오류를 피한다.
opt.foldexpr = "0"
opt.foldlevel = 99 -- 기본적으로 모든 fold를 펼쳐둠
opt.foldlevelstart = 99 -- 파일을 열 때도 모든 fold를 펼쳐둠

local treesitter_fold_filetypes = {
	c = true,
	css = true,
	dockerfile = true,
	go = true,
	gomod = true,
	gosum = true,
	gowork = true,
	html = true,
	json = true,
	lua = true,
	python = true,
	rust = true,
	vim = true,
	yaml = true,
}

local fold_group = vim.api.nvim_create_augroup("PsmFolds", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = fold_group,
	callback = function(args)
		local filetype = vim.bo[args.buf].filetype

		if not treesitter_fold_filetypes[filetype] then
			vim.opt_local.foldmethod = "manual"
			vim.opt_local.foldexpr = "0"
			return
		end

		local has_parser = pcall(vim.treesitter.get_parser, args.buf)

		if not has_parser then
			vim.opt_local.foldmethod = "manual"
			vim.opt_local.foldexpr = "0"
			return
		end

		vim.opt_local.foldmethod = "expr"
		vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end,
})

-- 편집 동작
opt.backspace = "indent,eol,start" -- 들여쓰기, 줄 끝, 입력 시작 지점에서 백스페이스 허용
opt.confirm = true -- 저장하지 않은 버퍼를 닫을 때 확인
opt.ttimeoutlen = 10 -- ESC 단독 입력과 alt 키(ESC+문자) 시퀀스 구분 대기 시간(ms), tmux escape-time과 통일

-- 클립보드
opt.clipboard:append("unnamedplus") -- 시스템 클립보드를 기본 레지스터로 사용

-- 창 분할
opt.splitright = true -- 세로 분할을 오른쪽에 생성
opt.splitbelow = true -- 가로 분할을 아래쪽에 생성

-- 파일 상태
opt.swapfile = false -- swap 파일 생성 비활성화
opt.undofile = true -- Neovim 재시작 후에도 undo 기록 유지
opt.autoread = true -- 외부에서 바뀐 파일을 자동으로 다시 읽기
opt.updatetime = 250 -- CursorHold 이벤트와 파일 변경 감지를 더 빠르게 실행

local autoread_group = vim.api.nvim_create_augroup("PsmAutoread", { clear = true })

-- Neovim 밖에서 바뀐 파일을 안전한 시점에 다시 읽는다.
vim.api.nvim_create_autocmd({
	"FocusGained",
	"BufEnter",
	"CursorHold",
	"CursorHoldI",
	"TermClose",
	"TermLeave",
}, {
	group = autoread_group,
	callback = function()
		-- q:, q/, q? 로 열린 command-line window에서는 :checktime을 실행할 수 없다.
		if vim.fn.mode() == "c" or vim.fn.getcmdwintype() ~= "" then
			return
		end

		pcall(vim.cmd, "checktime")
	end,
})
