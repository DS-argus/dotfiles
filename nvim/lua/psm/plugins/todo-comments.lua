return {
	"folke/todo-comments.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local todo_comments = require("todo-comments")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "]t", function()
			todo_comments.jump_next()
		end, { desc = "다음 TODO로 이동" })

		keymap.set("n", "[t", function()
			todo_comments.jump_prev()
		end, { desc = "이전 TODO로 이동" })

		todo_comments.setup()
	end,
}
