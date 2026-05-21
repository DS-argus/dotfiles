local lint_enabled = false

local function clear_lint()
	vim.diagnostic.reset(nil, 0)
end

local function toggle_lint()
	local lint = require("lint")

	lint_enabled = not lint_enabled
	if lint_enabled then
		vim.notify("린트 활성화됨")
		lint.try_lint()
	else
		vim.notify("린트 비활성화됨")
		clear_lint()
	end
end

local function run_lint()
	require("lint").try_lint()
end

return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		{ "<leader>lt", toggle_lint, desc = "린트 토글" },
		{ "<leader>ll", run_lint, desc = "현재 파일 린트 실행" },
	},
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			-- javascript = { "eslint_d" },
			-- typescript = { "eslint_d" },
			-- javascriptreact = { "eslint_d" },
			-- typescriptreact = { "eslint_d" },
			-- svelte = { "eslint_d" },
			python = { "ruff" },
		}
	end,
}
