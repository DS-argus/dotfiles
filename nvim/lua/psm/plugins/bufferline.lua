return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = {
		options = {
			mode = "tabs",
			separator_style = "slant",
			diagnostics = "nvim_lsp",
			show_close_icon = false,
			show_buffer_close_icons = false,
		},
	},
	config = function()
		require("bufferline").setup({
			options = {
				mode = "tabs",
				separator_style = "slant",
				diagnostics = "nvim_lsp",
				show_close_icon = false,
				show_buffer_close_icons = false,
			},
		})

		-- Keybindings for navigating tabs
		vim.api.nvim_set_keymap("n", "<Tab>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
	end,
}
