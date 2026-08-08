return {
	"gbprod/nord.nvim",
	lazy = false,
	priority = 1000, -- 다른 UI 플러그인보다 먼저 컬러스킴을 로드
	config = function()
		-- 터미널 배경이 비치도록 Neovim 배경을 투명하게 만든다.
		-- Ghostty가 Nord 배경(#2E3440)을 opacity 0.85 + blur로 그리므로
		-- Neovim은 배경을 칠하지 않고 그대로 통과시킨다.
		local transparent = true

		require("nord").setup({
			-- transparent 옵션은 Normal과 SignColumn 배경만 비운다.
			-- float/statusline은 아래 on_highlights에서 따로 처리한다.
			transparent = transparent,
			terminal_colors = true, -- :terminal 버퍼도 Nord 팔레트를 사용
			diff = { mode = "bg" }, -- diff를 배경색으로 표시 (bg | fg)
			borders = true, -- 수직 분할 경계선을 보이게 유지
			errors = { mode = "bg" }, -- 진단/에러를 배경색으로 표시 (bg | fg | none)
			search = { theme = "vim" }, -- 검색 하이라이트 스타일 (vim | vscode)
			styles = {
				comments = { italic = true },
				keywords = {},
				functions = {},
				variables = {},
			},
			on_highlights = function(highlights, colors)
				if not transparent then
					return
				end

				-- floating window와 사이드바 계열도 배경을 비워
				-- 이전 tokyonight의 floats/sidebars = "transparent" 동작을 유지한다.
				-- fg는 테마 기본값을 그대로 쓴다.
				for _, group in ipairs({
					"NormalFloat",
					"FloatBorder",
					"FoldColumn",
					"StatusLine",
					"StatusLineNC",
				}) do
					if highlights[group] then
						highlights[group].bg = colors.none
					end
				end
			end,
		})

		-- 위 설정을 적용한 Nord 컬러스킴을 활성화한다.
		vim.cmd.colorscheme("nord")
	end,
}
