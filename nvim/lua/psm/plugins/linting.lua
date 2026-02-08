return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		local lint_enabled = false

		lint.linters_by_ft = {
			-- javascript = { "eslint_d" },
			-- typescript = { "eslint_d" },
			-- javascriptreact = { "eslint_d" },
			-- typescriptreact = { "eslint_d" },
			-- svelte = { "eslint_d" },
			python = { "ruff" },
		}

		-- Linting 결과 제거 함수
		local function clear_lint()
			vim.diagnostic.reset(nil, 0) -- 진단 결과 초기화
		end

		-- Linting On/Off 토글 키맵
		vim.keymap.set("n", "<leader>lt", function()
			lint_enabled = not lint_enabled -- Linting 활성화/비활성화 전환
			if lint_enabled then
				vim.notify("Linting Enabled")
				lint.try_lint() -- 바로 Linting 실행
			else
				vim.notify("Linting Disabled")
				clear_lint() -- 진단 결과 제거
			end
		end, { desc = "Toggle linting on/off" })

		-- 수동 Linting 실행 키맵
		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
