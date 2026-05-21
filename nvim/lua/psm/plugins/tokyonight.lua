return {
	"folke/tokyonight.nvim",
	priority = 1000, -- 다른 UI 플러그인보다 먼저 컬러스킴을 로드
	config = function()
		-- 터미널 배경이 비치도록 Neovim 배경을 투명하게 만든다.
		local transparent = true

		-- Tokyonight 기본 팔레트 위에 덮어쓸 색상 값들
		local bg = "#011628"
		local bg_dark = "#011423"
		local bg_highlight = "#143652"
		local bg_search = "#0A64AC"
		local bg_visual = "#275378"
		local fg = "#CBE0F0"
		local fg_dark = "#B4D0E9"
		local fg_gutter = "#627E97"
		local border = "#547998"

		require("tokyonight").setup({
			style = "storm", -- night, storm, moon, day 중 하나
			transparent = transparent,
			styles = {
				-- 사이드바와 floating window도 배경 투명 설정을 따른다.
				sidebars = transparent and "transparent" or "dark",
				floats = transparent and "transparent" or "dark",
			},
			-- Tokyonight가 계산한 색상 팔레트를 직접 수정한다.
			on_colors = function(colors)
				colors.bg = bg -- 기본 편집 영역 배경색
				colors.bg_dark = transparent and colors.none or bg_dark -- 더 어두운 배경 영역
				colors.bg_float = transparent and colors.none or bg_dark -- floating window 배경색
				colors.bg_highlight = bg_highlight -- 현재 줄/강조 영역 배경색
				colors.bg_popup = bg_dark -- 팝업 메뉴 배경색
				colors.bg_search = bg_search -- 검색 결과 하이라이트 배경색
				colors.bg_sidebar = transparent and colors.none or bg_dark -- 사이드바 배경색
				colors.bg_statusline = transparent and colors.none or bg_dark -- 상태줄 배경색
				colors.bg_visual = bg_visual -- visual mode 선택 영역 배경색
				colors.border = border -- floating window와 팝업 테두리 색
				colors.fg = fg -- 기본 텍스트 색
				colors.fg_dark = fg_dark -- 덜 강조된 텍스트 색
				colors.fg_float = fg -- floating window 텍스트 색
				colors.fg_gutter = fg_gutter -- 줄 번호와 sign column 색
				colors.fg_sidebar = fg_dark -- 사이드바 텍스트 색
			end,
		})

		-- 위 설정을 적용한 Tokyonight 컬러스킴을 활성화한다.
		vim.cmd([[colorscheme tokyonight]])
	end,
}
