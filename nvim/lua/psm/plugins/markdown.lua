return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		cmd = { "RenderMarkdown" },
		ft = { "markdown" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		main = "render-markdown",
		keys = {
			{
				"<leader>mr",
				"<cmd>RenderMarkdown buf_toggle<CR>",
				ft = "markdown",
				desc = "마크다운 렌더링 토글",
			},
		},
		config = function(_, opts)
			local render_markdown = require("render-markdown")

			render_markdown.setup(opts)
		end,
		opts = {
			enabled = false,
			preset = "obsidian",
			file_types = { "markdown" },
			completions = {
				lsp = { enabled = true },
			},
		},
	},
}
