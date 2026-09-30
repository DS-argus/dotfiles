require("full-border"):setup({
	type = ui.Border.ROUNDED,
})
require("session"):setup({
	sync_yanked = true,
})
require("git"):setup({
	order = 400,
})

function Linemode:size_and_mtime()
	if self._filename_priority == "size" then
		local size = self._file:size()
		return size and ya.readable_size(size) or "-"
	end
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time)
	else
		time = os.date("%b %d  %Y", time)
	end

	local size = self._file:size()
	return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end

-- Reserve the full filename before allocating the right-hand metadata.
-- Keep the standard v26.9.1 Current rendering, including drag/drop and ellipsis.
function Current:redraw()
	local files = self._folder.window
	if #files == 0 then
		return self:empty()
	end

	local left, right = {}, {}
	for _, file in ipairs(files) do
		local entity = Entity:new(file)
		local name = entity:redraw()
		local available = math.max(0, self._area.w - name:width())
		local mode = Linemode:new(file)
		local info = mode:redraw()

		-- First drop the timestamp, retaining size and Git status when they fit.
		if info:width() > available and self._tab.pref.linemode == "size_and_mtime" then
			mode._filename_priority = "size"
			info = mode:redraw()
		end
		-- Then drop the selected linemode, retaining plugin signs and padding.
		if info:width() > available then
			local signs = {}
			for _, child in ipairs(Linemode._children) do
				if child[1] ~= "solo" then
					signs[#signs + 1] = (type(child[1]) == "string" and mode[child[1]] or child[1])(mode)
				end
			end
			info = ui.Line(signs)
		end
		-- Even Git status yields to the filename in a very narrow pane.
		if info:width() > available then
			info = ui.Line {}
		end

		local max = math.max(0, self._area.w - info:width())
		name:truncate { max = max, ellipsis = entity:ellipsis(max) }
		left[#left + 1], right[#right + 1] = name, info
	end

	return {
		ui.List(left):area(self._area),
		ui.Text(right):area(self._area):align(ui.Align.RIGHT),
		table.unpack(Dnd:new(self._area):redraw()),
	}
end
