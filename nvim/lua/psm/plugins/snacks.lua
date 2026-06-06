-- 설정에서 사용할 picker 관련 함수 미리 정의
local function snacks()
	return require("snacks")
end

local file_picker_title = "Files  ⏎ open  ^T tab  ^S/^V split  H/I filter"

local function find_files()
	snacks().picker.files({
		hidden = true,
		ignored = false,
		title = file_picker_title,
		win = {
			input = {
				keys = {
					["H"] = { "toggle_hidden", mode = { "n", "i" } },
					["I"] = { "toggle_ignored", mode = { "n", "i" } },
				},
			},
			list = {
				keys = {
					["H"] = "toggle_hidden",
					["I"] = "toggle_ignored",
				},
			},
		},
	})
end

local function find_text()
	snacks().picker.grep()
end

local function find_recent()
	snacks().picker.recent()
end

local function find_word()
	snacks().picker.grep_word()
end

local function find_todos()
	snacks().picker.grep({
		search = [[\b(TODO|FIX|FIXME|HACK|WARN|PERF|NOTE|TEST)\b]],
		regex = true,
		live = false,
		hidden = true,
	})
end

-- snack configuration
return {
	"folke/snacks.nvim",
	priority = 900,
	lazy = false,
	---@type snacks.Config
	opts = {
		dashboard = {
			enabled = true,
			preset = {
				keys = {
					{ icon = " ", key = "e", desc = "New File", action = ":ene | startinsert" },
					{ icon = "󰱼 ", key = "p", desc = "Find File", action = find_files },
					{ icon = " ", key = "g", desc = "Find Text", action = find_text },
					{ icon = " ", key = "r", desc = "Recent Files", action = find_recent },
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
			sections = {
				{
					{ section = "header" },
					{ section = "keys", gap = 1 },
					{ padding = 0.5, text = { { "", width = 0 } } },
					{
						icon = " ",
						title = "Recent Files",
						section = "recent_files",
						indent = 2,
						padding = 1,
					},
					{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
					{ section = "startup" },
				},
			},
		},
		indent = {
			enabled = true,
			indent = { char = "┊" },
			animate = {
				enabled = true,
				style = "out",
				easing = "linear",
				duration = { step = 20, total = 500 },
			},
			scope = { enabled = true },
			chunk = {
				enabled = true,
				only_current = true,
				priority = 200,
				hl = "SnacksIndentChunk", ---@type string|string[] hl group for chunk scopes
				char = {
					corner_top = "╭",
					corner_bottom = "╰",
					horizontal = "─",
					vertical = "│",
					arrow = ">",
				},
			},
		},
		zen = {
			enabled = true,
			toggles = {
				dim = true, -- 현재 scope 밖 코드를 흐리게 표시
				git_signs = false, -- Zen 모드에서는 git sign 숨김
				mini_diff_signs = false, -- mini.diff sign을 쓰는 경우 숨김
				diagnostics = false, -- 진단 표시를 잠시 숨김
				inlay_hints = false, -- inlay hint를 잠시 숨김
			},
			center = true, -- Zen 창을 열 때 커서 위치를 가운데로 맞춤
			show = {
				statusline = true, -- Zen 모드에서는 상태줄 숨김
				tabline = false, -- Zen 모드에서는 탭라인 숨김
			},
			win = {
				style = "zen",
				width = 100, -- 집중 모드에서 사용할 편집 폭
				height = 0, -- 가능한 전체 높이 사용
				backdrop = {
					transparent = false,
					blend = 45,
				},
			},
			zoom = {
				toggles = {}, -- <leader>sm zoom은 UI 토글을 건드리지 않음
				center = false,
				show = {
					statusline = true,
					tabline = true,
				},
				win = {
					backdrop = false,
					width = 0, -- 현재 split을 전체 폭으로 확대
				},
			},
		},
		picker = { enabled = true },
		explorer = { enabled = false }, -- Yazi 및 기본 netrw 사용
		input = { enabled = true },
	},
	keys = {
		{
			"<leader>sm",
			function()
				snacks().zen.zoom()
			end,
			desc = "분할 최대화 토글",
		},
		{
			"<leader>sz",
			function()
				snacks().zen()
			end,
			desc = "Zen 모드 토글",
		},
		{
			"<leader>ff",
			find_files,
			desc = "파일 찾기",
		},
		{
			"<leader>fr",
			find_recent,
			desc = "최근 파일 찾기",
		},
		{
			"<leader>fs",
			find_text,
			desc = "문자열 찾기",
		},
		{
			"<leader>fc",
			find_word,
			desc = "커서 아래 문자열 찾기",
		},
		{
			"<leader>ft",
			find_todos,
			desc = "TODO 찾기",
		},
	},
}
