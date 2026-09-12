local M = {}

local function range()
	local first, last = vim.fn.getpos("v"), vim.fn.getpos(".")
	if first[2] > last[2] or (first[2] == last[2] and first[3] > last[3]) then
		first, last = last, first
	end
	return { first[2], first[3], last[2], last[3] }
end

local function select_range(value)
	if vim.fn.mode() ~= "v" then
		vim.cmd.normal({ "v", bang = true })
	end
	vim.api.nvim_win_set_cursor(0, { value[1], value[2] - 1 })
	vim.cmd.normal({ "o", bang = true })
	vim.api.nvim_win_set_cursor(0, { value[3], value[4] - 1 })
end

local function start()
	local parser = vim.treesitter.get_parser()
	if not parser then
		return
	end
	local row = vim.api.nvim_win_get_cursor(0)[1] - 1
	parser:parse({ row, row + 1 })
	local node = vim.treesitter.get_node({ ignore_injections = false })
	if not node then
		return
	end
	local sr, sc, er, ec = node:range()
	if sr == er and sc == ec then
		return
	end
	if ec == 0 then
		er = er - 1
		ec = math.max(1, #vim.api.nvim_buf_get_lines(0, er, er + 1, false)[1])
	end
	select_range({ sr + 1, sc + 1, er + 1, ec })
	vim.b.psm_ts_selection = { tick = vim.b.changedtick, ranges = { range() } }
end

local function history()
	local state = vim.b.psm_ts_selection
	if state and state.tick == vim.b.changedtick and vim.deep_equal(state.ranges[#state.ranges], range()) then
		return state
	end
	vim.b.psm_ts_selection = nil
end

local function grow()
	local state = history() or { tick = vim.b.changedtick, ranges = { range() } }
	vim.treesitter.select("parent")
	local selected = range()
	if not vim.deep_equal(state.ranges[#state.ranges], selected) then
		table.insert(state.ranges, selected)
	end
	vim.b.psm_ts_selection = state
end

local function shrink()
	local state = history()
	if state and #state.ranges > 1 then
		table.remove(state.ranges)
		select_range(state.ranges[#state.ranges])
		vim.b.psm_ts_selection = state
	end
end

function M.attach(buf)
	-- Native parent navigation, with the old initial-node/Backspace behavior.
	vim.keymap.set("n", "<leader>v", start, { buffer = buf, silent = true, desc = "Select syntax node" })
	vim.keymap.set("x", "<leader>v", grow, { buffer = buf, silent = true, desc = "Expand syntax selection" })
	vim.keymap.set("x", "<BS>", shrink, { buffer = buf, silent = true, desc = "Restore previous syntax selection" })
end

function M.detach(buf)
	vim.b[buf].psm_ts_selection = nil
	for _, mapping in ipairs({ { "n", "<leader>v" }, { "x", "<leader>v" }, { "x", "<BS>" } }) do
		pcall(vim.keymap.del, mapping[1], mapping[2], { buffer = buf })
	end
end

return M
