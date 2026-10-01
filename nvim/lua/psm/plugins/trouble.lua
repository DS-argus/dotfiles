return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
	-- opts가 있어야 lazy.nvim이 setup()을 호출해 :Trouble 명령이 등록된다.
	opts = {},
	cmd = "Trouble",
	keys = {
		{ "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "워크스페이스 진단 보기" },
		{ "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "현재 파일 진단 보기" },
		{ "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "심볼 아웃라인 보기" },
		{ "<leader>xr", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", desc = "LSP 정의/참조 보기" },
		{ "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "퀵픽스 목록 보기" },
		{ "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "위치 목록 보기" },
		{ "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "TODO 목록 보기" },
	},
}
