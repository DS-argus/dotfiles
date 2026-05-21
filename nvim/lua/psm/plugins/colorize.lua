return {
	"catgoose/nvim-colorizer.lua",
	event = "BufReadPre",
	opts = {
		filetypes = { "*" }, -- 모든 파일에서 활성화
		user_default_options = {
			names = false, -- 색상 이름 감지
		},
	},
}
