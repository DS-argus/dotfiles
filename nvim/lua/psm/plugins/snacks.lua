local function snacks()
	return require("snacks")
end

local function current_explorer()
	local picker = snacks().picker.get({ source = "explorer" })
	if vim.islist(picker) then
		return picker[1]
	end
	return picker
end

local function toggle_explorer()
	local picker = current_explorer()
	if picker then
		picker:close()
		return
	end

	snacks().explorer()
end

local function explorer_action(action)
	local picker = current_explorer()
	if picker then
		picker:action(action)
		return
	end

	snacks().explorer()
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
						action = function()
							snacks().explorer()
						end,
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
			"<leader>ee",
			function()
				toggle_explorer()
			end,
			desc = "파일 탐색기 토글",
		},
		{
			"<leader>ef",
			function()
				snacks().explorer.reveal()
			end,
			desc = "현재 파일 위치 보기",
		},
		{
			"<leader>ec",
			function()
				explorer_action("explorer_close_all")
			end,
			desc = "탐색기 접기",
		},
		{
			"<leader>er",
			function()
				explorer_action("explorer_update")
			end,
			desc = "탐색기 새로고침",
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
