local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim" -- ~/.local/share/nvim 하위 /lazy/lazy.nvim에 lazy.nvim 플러그인 매니저 다운로드
if not vim.uv.fs_stat(lazypath) then -- lazypath 경로가 존재하지 않으면 git clone
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath) -- lazypath를 runtime path에 앞쪽에 추가

require("lazy").setup({
	{ import = "psm.plugins" }, -- psm/plugins 하위 플러그인 설정 로드
	{ import = "psm.plugins.lsp" }, -- psm/plugins/lsp/ 하위 플러그인 설정 로드
}, {
	checker = {
		enabled = true, -- 플러그인 업데이트 확인
		notify = true, -- 업데이트 있으면 알림
	},
	change_detection = {
		notify = false, -- 설정 파일 변경 감지
	},
})
