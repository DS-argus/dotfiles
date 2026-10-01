-- lazy.nvim
return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		presets = {
			-- K(hover)와 signature help 창에 테두리를 그린다.
			-- preset은 views보다 나중에 합쳐지므로 테두리 스타일도 여기서 지정한다.
			lsp_doc_border = {
				views = {
					hover = {
						border = { style = "double" },
					},
				},
			},
		},
		views = {
			cmdline_popup = {
				position = { row = 5, col = "50%" },
				size = { width = 60, height = "auto" },
			},
			popupmenu = {
				relative = "editor",
				position = { row = 8, col = "50%" },
				size = { width = 60, height = 10 },
				border = { style = "rounded", padding = { 0, 1 } },
				win_options = {
					winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
				},
			},
		},
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	keys = {
		{ "<leader>nd", "<cmd>NoiceDismiss<CR>", desc = "Noice 메시지 닫기" },
	},
}
