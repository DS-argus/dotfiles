return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		{ "windwp/nvim-ts-autotag", opts = {} },
	},
	config = function()
		local treesitter = require("nvim-treesitter")
		local editor = require("psm.core.treesitter")

		treesitter.setup({ install_dir = vim.fn.stdpath("data") .. "/site" })
		editor.setup()

		-- Include all previously installed parsers, including the web languages.
		treesitter
			.install({
				"bash",
				"c",
				"css",
				"dockerfile",
				"gitignore",
				"go",
				"gomod",
				"gosum",
				"gowork",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"prisma",
				"python",
				"query",
				"rust",
				"svelte",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			})
			:await(function(err)
				if not err then
					-- First installation can finish after the initial FileType event.
					vim.schedule(editor.refresh)
				end
			end)
	end,
}
