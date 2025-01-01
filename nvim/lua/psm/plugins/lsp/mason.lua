return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				-- python
				"pyright",
				-- lua
				"lua_ls",
				-- rust
				"rust_analyzer",
				-- others
				"html",
				"cssls",
			},
			automatic_installation = false,
		})

		mason_tool_installer.setup({
			ensure_installed = {
				-- python
				"black", -- python formatter
				"isort", -- python import formatter
				"pylint", -- python linter
				-- lua
				"stylua", -- lua formatter
				-- others
				"prettier", -- HTML/CSS/JS formatter
			},
		})
	end,
}
