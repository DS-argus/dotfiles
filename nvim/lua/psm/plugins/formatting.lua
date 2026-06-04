return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		formatters_by_ft = {
			css = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
			go = { "goimports", "gofmt" },
			lua = { "stylua" },
			python = { "ruff_organize_imports", "ruff_format" },
			rust = { "rustfmt", lsp_format = "fallback" },
		},
		format_on_save = {
			lsp_format = "fallback",
			timeout_ms = 1000,
		},
		-- 저장 후 비동기 포맷. 포맷 결과가 저장 뒤 적용되어 modified 상태가 될 수 있어 보류.
		-- format_after_save = {
		-- 	lsp_format = "fallback",
		-- },
	},
	keys = {
		{
			"<leader>mf",
			function()
				require("conform").format({
					lsp_format = "fallback",
					async = true,
					timeout_ms = 3000,
				})
			end,
			mode = { "n", "v" },
			desc = "파일/선택 영역 포맷팅",
		},
	},
	config = function(_, opts)
		require("conform").setup(opts)
	end,
}
