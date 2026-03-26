local M = {}

-- Neovim pane 여부를 user var로 판단한다.
local function is_nvim(pane)
	return pane:get_user_vars().IS_NVIM == "true"
end

function M.split_nav(wezterm, direction, key)
	local act = wezterm.action

	return wezterm.action_callback(function(window, pane)
		if is_nvim(pane) then
			window:perform_action(act.SendKey({ key = key, mods = "CTRL" }), pane)
		else
			window:perform_action(act.ActivatePaneDirection(direction), pane)
		end
	end)
end

function M.switch_workspace(wezterm)
	local act = wezterm.action

	return wezterm.action_callback(function(window, pane)
		window:perform_action(
			act.PromptInputLine({
				description = "Enter workspace name",
				action = wezterm.action_callback(function(win, inner_pane, line)
					if line and #line > 0 then
						win:perform_action(act.SwitchToWorkspace({ name = line }), inner_pane)
					end
				end),
			}),
			pane
		)
	end)
end

function M.rename_workspace(wezterm)
	local act = wezterm.action
	local mux = wezterm.mux

	return wezterm.action_callback(function(window, pane)
		local current = window:active_workspace()

		window:perform_action(
			act.PromptInputLine({
				description = "Rename workspace (" .. current .. ")",
				action = wezterm.action_callback(function(_, _, line)
					if line and #line > 0 and line ~= current then
						mux.rename_workspace(current, line)
					end
				end),
			}),
			pane
		)
	end)
end

local function workspace_choices(mux, current)
	local names = mux.get_workspace_names()
	local workspace_stats = {}

	for _, mux_window in ipairs(mux.all_windows()) do
		local name = mux_window:get_workspace()
		local stats = workspace_stats[name]

		if not stats then
			stats = { tabs = 0 }
			workspace_stats[name] = stats
		end

		stats.tabs = stats.tabs + #mux_window:tabs()
	end

	table.sort(names)

	local choices = {}
	for _, name in ipairs(names) do
		local stats = workspace_stats[name] or { tabs = 0 }
		local label = string.format("%s  [tab %d]", name, stats.tabs)
		if name == current then
			label = "[current] " .. label
		end

		table.insert(choices, {
			id = name,
			label = label,
		})
	end

	return choices
end

local function workspace_tab_choices(mux, workspace_name)
	local choices = {}
	local workspace_tab_index = 0

	for _, mux_window in ipairs(mux.all_windows()) do
		if mux_window:get_workspace() == workspace_name then
			for _, tab in ipairs(mux_window:tabs()) do
				workspace_tab_index = workspace_tab_index + 1

				local title = tab:get_title()
				local active_pane = tab:active_pane()
				local pane_count = #tab:panes()

				if (not title or title == "") and active_pane then
					title = active_pane:get_title()
				end

				if not title or title == "" then
					title = "untitled"
				end

				table.insert(choices, {
					id = tostring(tab:tab_id()),
					label = string.format("[tab %d] %s [pane %d]", workspace_tab_index, title, pane_count),
				})
			end
		end
	end

	return choices
end

function M.select_workspace(wezterm)
	local act = wezterm.action
	local mux = wezterm.mux
	local time = wezterm.time

	local function select_workspace_tab(window, pane, workspace_name)
		local choices = workspace_tab_choices(mux, workspace_name)

		if #choices == 0 then
			window:perform_action(act.SwitchToWorkspace({ name = workspace_name }), pane)
			return
		end

		local function show_tab_selector()
			local target_pane = window:active_pane()
			if not target_pane then
				return
			end

			window:perform_action(
				act.InputSelector({
					title = string.format("Workspace: %s", workspace_name),
					choices = choices,
					fuzzy = false,
					alphabet = "",
					description = "j/k or arrows: move, Enter: open tab",
					fuzzy_description = "Tab search: ",
					action = wezterm.action_callback(function(_, _, id, _)
						if not id then
							return
						end

						local target_tab = mux.get_tab(tonumber(id))
						if not target_tab then
							return
						end

						local active_pane = target_tab:active_pane()
						if active_pane then
							active_pane:activate()
						else
							target_tab:activate()
						end
					end),
				}),
				target_pane
			)
		end

		-- workspace 전환 직후 바로 selector를 띄우면 타이밍 이슈가 날 수 있어서
		-- 짧게 지연한 뒤 tab selector를 연다.
		if window:active_workspace() ~= workspace_name then
			window:perform_action(act.SwitchToWorkspace({ name = workspace_name }), pane)
			time.call_after(0.05, show_tab_selector)
		else
			show_tab_selector()
		end
	end

	return wezterm.action_callback(function(window, pane)
		-- leader+s를 누른 직후 같은 키 입력이 selector에 흘러들어가면
		-- 곧바로 검색 모드로 들어가 보일 수 있어서 한 템포 늦게 연다.
		time.call_after(0.05, function()
			window:perform_action(
				act.InputSelector({
					title = "Select workspace",
					choices = workspace_choices(mux, window:active_workspace()),
					fuzzy = false,
					alphabet = "",
					description = "j/k or arrows: move, Enter: open tabs, /: filter",
					fuzzy_description = "Workspace search: ",
					action = wezterm.action_callback(function(inner_window, inner_pane, id, _)
						if id and #id > 0 then
							select_workspace_tab(inner_window, inner_pane, id)
						end
					end),
				}),
				pane
			)
		end)
	end)
end

return M
