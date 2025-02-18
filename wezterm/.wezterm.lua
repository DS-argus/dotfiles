-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Font : 한글, 영어 글꼴 다르게 설정
config.font = wezterm.font_with_fallback({
	{ family = "JetBrains Mono", weight = "Bold", style = "Normal" },
	{ family = "D2Coding ligature", weight = "Black" },
})

config.font_size = 14

-- cursor
config.animation_fps = 120
config.cursor_blink_ease_in = "EaseOut"
config.cursor_blink_ease_out = "EaseOut"
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 800

-- scroll bar
config.enable_scroll_bar = false

-- tab
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.show_tab_index_in_tab_bar = false
config.switch_to_last_active_tab_when_closing_tab = true
config.tab_max_width = 25
config.tab_bar_at_bottom = false
config.show_new_tab_button_in_tab_bar = false

-- window
config.window_padding = {
	left = 0,
	right = 0,
	top = 10,
	bottom = 7.5,
}
config.window_frame = {
	font = wezterm.font("JetBrains Mono", { weight = "Black" }),
	font_size = 13,
}
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.85
config.macos_window_background_blur = 0

-- config.color_scheme = "Tokyo Night"
-- my coolnight colorscheme:
config.colors = {
	foreground = "#CBE0F0",
	background = "#011423",
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	-- 회색이 너무 흐리게 보여서 좀 밝게 수정함
	ansi = { "#707070", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
	brights = { "#707070", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, _, _, _, hover, max_width)
	-- 기본 색상
	local edge_background = "#033259" -- 기존 selection_bg와 비슷한 톤
	local background = "#011423" -- 기존 background 색과 동일
	local foreground = "#CBE0F0" -- 기존 foreground 색과 동일

	-- 활성 탭
	if tab.is_active then
		background = "#024059" -- selection_bg에서 약간 밝은 색
		foreground = "#47FF9C" -- cursor_bg와 동일 (눈에 띄게)
	elseif hover then
		-- 호버 시
		background = "#033259" -- selection_bg와 동일
		foreground = "#44FFB1" -- 기존 ansi 색상 중 초록 계열
	end

	local edge_foreground = background

	local title = tab_title(tab)

	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	-- title = wezterm.truncate_right(title, max_width)
	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)

-- -- -- CPU 아이콘
-- local cpu_icon = wezterm.format({
-- 	{ Foreground = { Color = "#90EE90" } }, -- 연두색
-- 	{ Text = wezterm.nerdfonts.md_cpu_64_bit }, -- CPU 아이콘
-- })
--
-- local memory_icon = wezterm.format({
-- 	{ Foreground = { Color = "#90EE90" } }, -- 연두색
-- 	{ Text = wezterm.nerdfonts.md_memory }, -- CPU 아이콘
-- })
--
-- -- CPU 사용량 함수
-- local function darwin_cpu_usage()
-- 	local success, stdout, stderr = wezterm.run_child_process({ "top", "-l", "1" })
-- 	if success then
-- 		local user, sys, idle = stdout:match("CPU usage:%s+(%d+%.%d+)%% user,%s+(%d+%.%d+)%% sys,%s+(%d+%.%d+)%% idle")
-- 		if user and sys and idle then
-- 			return string.format("%s %s%%", cpu_icon, math.floor(user + sys))
-- 		end
-- 	end
-- 	return "CPU: N/A"
-- end
--
-- -- 메모리 사용량 함수
-- local function darwin_memory_usage()
-- 	local pagesize = nil
-- 	local total = nil
--
-- 	-- 페이지 크기 가져오기
-- 	local success, stdout, stderr = wezterm.run_child_process({ "sysctl", "-n", "hw.pagesize" })
-- 	if success then
-- 		pagesize = tonumber(stdout)
-- 	end
--
-- 	-- 총 메모리 크기 가져오기
-- 	success, stdout, stderr = wezterm.run_child_process({ "sysctl", "-n", "hw.memsize" })
-- 	if success then
-- 		total = tonumber(stdout)
-- 	end
--
-- 	if pagesize ~= nil and total ~= nil then
-- 		success, stdout, stderr = wezterm.run_child_process({ "vm_stat" })
-- 		if success then
-- 			local free_pages = tonumber(stdout:match("Pages free:%s+(%d+)")) or 0
-- 			local active_pages = tonumber(stdout:match("Pages active:%s+(%d+)")) or 0
-- 			local wired_pages = tonumber(stdout:match("Pages wired down:%s+(%d+)")) or 0
-- 			local speculative_pages = tonumber(stdout:match("Pages speculative:%s+(%d+)")) or 0
--
-- 			local bytes_free = free_pages * pagesize
-- 			local bytes_active = active_pages * pagesize
-- 			local bytes_wired = wired_pages * pagesize
-- 			local bytes_speculative = speculative_pages * pagesize
-- 			local bytes_used = bytes_active + bytes_wired + bytes_speculative
--
-- 			return string.format(
-- 				"%s %.1fGB/%.0fGB",
-- 				memory_icon, -- 메모리 아이콘
-- 				bytes_used / 1024 / 1024 / 1024,
-- 				total / 1024 / 1024 / 1024
-- 			)
-- 		end
-- 	end
-- 	return "󰍛 N/A"
-- end
--
-- wezterm.on("update-right-status", function(window, _)
-- 	-- 날짜 시간
-- 	local date = wezterm.strftime("%Y.%m.%d %H:%M:%S")
--
-- 	-- 배터리 상태
-- 	local bat = "🔋 N/A" -- 기본값 설정
-- 	for _, b in ipairs(wezterm.battery_info()) do
-- 		if b.state_of_charge then
-- 			bat = "🔋" .. string.format("%.0f%%", b.state_of_charge * 100)
-- 			break -- 첫 번째 배터리 정보만 사용
-- 		end
-- 	end
--
-- 	-- CPU 사용량
-- 	local os_name = wezterm.target_triple
-- 	local cpu_info = "CPU: N/A"
-- 	local memory_info = "󰍛 N/A"
--
-- 	if os_name:match("^darwin") or os_name:match("^aarch64") then
-- 		cpu_info = darwin_cpu_usage()
-- 		memory_info = darwin_memory_usage()
-- 	elseif os_name:match("^linux") then
-- 		cpu_info = "Not implemented for Linux"
-- 		memory_info = "Not implemented for Linux"
-- 	end
--
-- 	-- 오른쪽 상태 표시줄 업데이트
-- 	window:set_right_status(wezterm.format({
-- 		{ Text = bat .. " | " .. cpu_info .. " | " .. memory_info .. " | " .. date },
-- 	}))
-- end)
-- -- and finally, return the configuration to wezterm
--
return config
