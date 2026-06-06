return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "버퍼 키맵 보기",
		},
		{
			"<C-w><space>",
			function()
				require("which-key").show({ keys = "<C-w>", loop = true })
			end,
			desc = "창 키맵 보기",
		},
	},
	opts = {
		preset = "helix",
		delay = function(ctx)
			return ctx.plugin and 0 or 200
		end,
		expand = 1,
		spec = {
			{ "<leader>c", group = "코드" },
			{ "<leader>f", group = "찾기" },
			{ "<leader>l", group = "린트/LSP" },
			{ "<leader>m", group = "문서/포맷" },
			{ "<leader>n", group = "알림" },
			{ "<leader>r", group = "이름 변경" },
			{ "<leader>s", group = "검색/창/집중" },
			{ "<leader>t", group = "탭" },
			{ "<leader>x", group = "진단/문제" },
			{ "[", group = "이전" },
			{ "]", group = "다음" },
		},
	},
}
