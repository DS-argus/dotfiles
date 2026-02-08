return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"neovim/nvim-lspconfig", -- LSP 서버 설정을 위해 필요!
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		-- 1. Mason UI 설정
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- 2. Mason-LspConfig로 LSP 서버 설치만 관리
		local servers = {
			"pyright",
			"lua_ls",
			"rust_analyzer",
		}
		mason_lspconfig.setup({
			ensure_installed = servers,
			automatic_installation = false,
		})

		-- 3. Tool 설치 (포매터, 린터 등) - LSP와 분리
		mason_tool_installer.setup({
			ensure_installed = {
				"ruff", -- python linter & formatter (black, isort, pylint 대체)
				"stylua", -- lua formatter
				"prettier", -- HTML/CSS/JS formatter
			},
			run_on_start = false, -- 시작 시 자동 실행 비활성화
		})

		-- 4. LSP 서버 개별 설정은 lspconfig.lua에서 처리 (mason.lua에서는 하지 않음)
	end,
}
