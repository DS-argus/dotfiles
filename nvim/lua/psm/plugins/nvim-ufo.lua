return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async" },
	event = "BufRead",
	opts = {},
	config = function()
		-- Fold options
		vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
		vim.o.foldcolumn = "0" -- '0' is not bad
		vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true
		require("ufo").setup({
			provider_selector = function(bufnr, filetype, buftype)
				return { "treesitter", "indent" }
			end,
		})
	end,
	-- init = function()
	-- -- Using ufo provider need remap zR and zM. If Neovim is 0.6.1, remap yourself
	-- vim.keymap.set("n", "zR", function()
	-- require("ufo").openAllFolds()
	-- end)
	-- vim.keymap.set("n", "zM", function()
	-- require("ufo").closeAllFolds()
	-- end)
	-- end,
}
