return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signs_staged = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signs_staged_enable = true,
		signcolumn = true,
		numhl = true,
		linehl = false,
		word_diff = false,
		watch_gitdir = {
			follow_files = true,
		},
		auto_attach = true,
		attach_to_untracked = false,
		current_line_blame = false,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			delay = 1000,
			ignore_whitespace = false,
			virt_text_priority = 100,
			use_focus = true,
		},
		current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
		blame_formatter = nil,
		sign_priority = 6,
		update_debounce = 100,
		status_formatter = nil,
		max_file_length = 40000,
		preview_config = {
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")
			local function map(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
			end

			-- 변경 블록 이동
			map("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end, "다음 Git 변경")
			map("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end, "이전 Git 변경")

			-- 변경 블록 조작 및 확인
			map("n", "<leader>hs", gitsigns.stage_hunk, "변경 블록 스테이지")
			map("n", "<leader>hr", gitsigns.reset_hunk, "변경 블록 되돌리기")
			map("v", "<leader>hs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "선택 변경 블록 스테이지")
			map("v", "<leader>hr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "선택 변경 블록 되돌리기")
			map("n", "<leader>hS", gitsigns.stage_buffer, "버퍼 스테이지")
			map("n", "<leader>hR", gitsigns.reset_buffer, "버퍼 되돌리기")
			map("n", "<leader>hp", gitsigns.preview_hunk, "변경 블록 미리보기")
			map("n", "<leader>hi", gitsigns.preview_hunk_inline, "인라인 변경 미리보기")
			map("n", "<leader>hb", function()
				gitsigns.blame_line({ full = true })
			end, "현재 줄 Git blame")
			map("n", "<leader>hd", gitsigns.diffthis, "현재 파일 diff")
			map("n", "<leader>hD", function()
				gitsigns.diffthis("~")
			end, "이전 커밋과 diff")
			map("n", "<leader>hQ", function()
				gitsigns.setqflist("all")
			end, "저장소 변경 Quickfix")
			map("n", "<leader>hq", gitsigns.setqflist, "버퍼 변경 Quickfix")

			-- 표시 토글 및 text object
			map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "현재 줄 Git blame 토글")
			map("n", "<leader>tw", gitsigns.toggle_word_diff, "단어 단위 Git diff 토글")
			map({ "o", "x" }, "ih", gitsigns.select_hunk, "Git 변경 블록 선택")
		end,
	},
}
