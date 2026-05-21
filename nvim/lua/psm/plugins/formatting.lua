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
		},
		format_after_save = {
			lsp_fallback = true,
			-- async = true, -- 비동기 포맷팅으로 변경 (속도 향상)
			-- timeout_ms = 3000, -- 타임아웃 증가
		},
	},
	keys = {
		{
			"<leader>mf",
			function()
				require("conform").format({
					lsp_fallback = true,
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
