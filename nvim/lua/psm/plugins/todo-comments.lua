return {
	"folke/todo-comments.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{
			"]t",
			function()
				require("todo-comments").jump_next()
			end,
			desc = "다음 TODO로 이동",
		},
		{
			"[t",
			function()
				require("todo-comments").jump_prev()
			end,
			desc = "이전 TODO로 이동",
		},
	},
	config = function()
		require("todo-comments").setup()
	end,
}
