return {
	"catgoose/nvim-colorizer.lua",
	event = "BufReadPre",
	opts = {
		filetypes = { "*" }, -- 모든 파일에서 활성화
		user_default_options = {
			names = false, -- 색상 이름 감지
			-- names_custom = false, -- 사용자 정의 색상 이름 비활성화
			-- RGB = true, -- #RGB 색상 감지
			-- RRGGBB = true, -- #RRGGBB 색상 감지
			-- RRGGBBAA = false, -- #RRGGBBAA 색상 비활성화
			-- AARRGGBB = false, -- 0xAARRGGBB 색상 비활성화
			-- rgb_fn = false, -- rgb() 함수 비활성화
			-- hsl_fn = false, -- hsl() 함수 비활성화
			-- css = false, -- 모든 CSS 기능 비활성화
			-- css_fn = false, -- CSS 함수 비활성화
			-- mode = "background", -- 배경색으로 색상 표시
			-- tailwind = false, -- Tailwind CSS 색상 비활성화
			-- sass = { enable = false, parsers = { "css" } }, -- Sass 색상 비활성화
			-- virtualtext = "■", -- 가상 텍스트 블록으로 표시할 문자
			-- virtualtext_inline = false, -- 가상 텍스트를 인라인으로 표시하지 않음
			-- virtualtext_mode = "foreground", -- 가상 텍스트를 전경색으로 표시
			-- always_update = false, -- 비활성화된 버퍼에서 색상 업데이트 비활성화
		},
		-- buftypes = {}, -- 특정 버퍼 타입 적용 없음
		-- user_commands = true, -- 모든 사용자 명령 활성화
	},
}
