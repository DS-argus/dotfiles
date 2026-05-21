return {
	"windwp/nvim-autopairs",
	event = {
		"InsertEnter",
	},
	dependencies = {
		"hrsh7th/nvim-cmp",
	},
	config = function()
		-- import nvim-autopairs
		local autopairs = require("nvim-autopairs")

		-- configure autopairs
		autopairs.setup({
			check_ts = true, -- enable treesitter
			ts_config = { -- 언어별 예외 설정
				lua = { "string" }, -- don't add pairs in lua string treesitter nodes
				javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
				java = false, -- don't check treesitter on java
			},
		})

		-- nvim-cmp 제공 자동완성 기능과 연동
		local cmp_autopairs = require("nvim-autopairs.completion.cmp") -- import nvim-autopairs completion functionality
		local cmp = require("cmp") -- import nvim-cmp plugin (completions plugin)
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done()) -- make autopairs and completion work together
	end,
}
