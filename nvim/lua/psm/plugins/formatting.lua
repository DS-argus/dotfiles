return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				-- javascript = { "prettier" },
				-- typescript = { "prettier" },
				-- javascriptreact = { "prettier" },
				-- typescriptreact = { "prettier" },
				-- svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				-- graphql = { "prettier" },
				-- liquid = { "prettier" },
				lua = { "stylua" },
				python = { "ruff_organize_imports", "ruff_format" },
			},
			format_after_save = {
				lsp_fallback = true,
				-- async = true, -- 비동기 포맷팅으로 변경 (속도 향상)
				-- timeout_ms = 3000, -- 타임아웃 증가
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>mf", function()
			conform.format({
				lsp_fallback = true,
				async = true, -- 비동기 포맷팅으로 변경
				timeout_ms = 3000,
			})
		end, { desc = "파일/선택 영역 포맷팅" })
	end,
}
