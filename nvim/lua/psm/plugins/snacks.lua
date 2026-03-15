local function snacks()
	return require("snacks")
end

return {
	"folke/snacks.nvim",
	priority = 900,
	lazy = false,
	---@type snacks.Config
	opts = {
		dashboard = {
			enabled = true,
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				{ section = "startup" },
			},
			preset = {
				header = [[
  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
				]],
				keys = {
					{
						icon = " ",
						key = "e",
						desc = "새 파일",
						action = ":ene | startinsert",
					},
					{
						icon = " ",
						key = "f",
						desc = "파일 탐색기",
						action = ":NvimTreeToggle",
					},
					{
						icon = "󰱼 ",
						key = "p",
						desc = "파일 찾기",
						action = function()
							snacks().picker.files()
						end,
					},
					{
						icon = " ",
						key = "g",
						desc = "문자열 찾기",
						action = function()
							snacks().picker.grep()
						end,
					},
					{
						icon = " ",
						key = "r",
						desc = "최근 파일",
						action = function()
							snacks().picker.recent()
						end,
					},
					{
						icon = " ",
						key = "q",
						desc = "NVIM 종료",
						action = ":qa",
					},
				},
			},
		},
		explorer = {
			enabled = true,
			replace_netrw = false,
		},
		indent = {
			enabled = true,
			indent = {
				char = "┊",
			},
			scope = {
				enabled = false,
			},
			animate = {
				enabled = false,
			},
		},
		input = {
			enabled = true,
		},
		picker = {
			enabled = true,
			sources = {
				explorer = {
					hidden = true,
					ignored = false,
					exclude = { "**/.DS_Store" },
					layout = { preset = "sidebar", preview = false },
				},
			},
		},
		zen = {
			enabled = true,
		},
	},
	keys = {
		{
			"<leader>es",
			function()
				snacks().explorer()
			end,
			desc = "Snacks 탐색기 열기",
		},
		{
			"<leader>sm",
			function()
				snacks().zen.zoom()
			end,
			desc = "분할 최대화 토글",
		},
		{
			"<leader>ff",
			function()
				snacks().picker.files()
			end,
			desc = "파일 찾기",
		},
		{
			"<leader>fr",
			function()
				snacks().picker.recent()
			end,
			desc = "최근 파일 찾기",
		},
		{
			"<leader>fs",
			function()
				snacks().picker.grep()
			end,
			desc = "문자열 찾기",
		},
		{
			"<leader>fc",
			function()
				snacks().picker.grep_word()
			end,
			desc = "커서 아래 문자열 찾기",
		},
		{
			"<leader>ft",
			function()
				snacks().picker.grep({
					search = [[\b(TODO|FIX|FIXME|HACK|WARN|PERF|NOTE|TEST)\b]],
					regex = true,
					live = false,
					hidden = true,
				})
			end,
			desc = "TODO 찾기",
		},
	},
}
