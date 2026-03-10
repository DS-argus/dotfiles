require("starship"):setup({
	-- -- Hide flags (such as filter, find and search). This can be beneficial for starship themes
	-- -- which are intended to go across the entire width of the terminal.
	hide_flags = true,
	-- -- Whether to place flags after the starship prompt. False means the flags will be placed before the prompt.
	flags_after_prompt = true,
	-- -- Custom starship configuration file to use
	config_file = "~/.config/starship/yazi.toml",
	-- -- Whether to enable support for starship's right prompt (i.e. `starship prompt --right`).
	show_right_prompt = false,
	-- -- Whether to hide the count widget, in case you want only your right prompt to show up. Only has
	-- -- an effect when `show_right_prompt = true`
	hide_count = false,
	-- -- Separator to place between the right prompt and the count widget. Use `count_separator = ""`
	-- -- to have no space between the widgets.
	count_separator = " ",
})

require("full-border"):setup({
	type = ui.Border.ROUNDED,
})

function Linemode:size_and_mtime()
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
