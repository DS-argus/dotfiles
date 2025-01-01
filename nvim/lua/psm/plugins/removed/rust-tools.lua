return {
	"simrat39/rust-tools.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
	},
	config = function()
		local rt = require("rust-tools")

		rt.setup({
			server = {
				-- capabilities = require("lspconfig").capabilities,
				on_attach = function(_, bufnr)
					local opts = { buffer = bufnr }
					-- Rust-specific 키 매핑
					vim.keymap.set("n", "K", rt.hover_actions.hover_actions, opts)
					vim.keymap.set("n", "<leader>ca", rt.code_action_group.code_action_group, opts)
				end,
				settings = {
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true, -- 모든 Cargo feature 활성화
						},
						checkOnSave = {
							command = "clippy", -- 저장 시 Clippy 실행
						},
					},
				},
			},
			tools = {
				-- Inline hints 설정
				inlay_hints = {
					auto = true, -- 자동으로 힌트 표시
					show_parameter_hints = true,
					parameter_hints_prefix = "<- ",
					other_hints_prefix = "=> ",
				},
			},
		})
	end,
}
