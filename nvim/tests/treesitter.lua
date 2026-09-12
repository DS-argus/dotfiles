vim.g.mapleader = " "

local script = debug.getinfo(1, "S").source:sub(2)
local nvim_root = vim.fs.dirname(vim.fs.dirname(vim.fs.normalize(script)))
local lazy_root = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
local treesitter_root = vim.fs.joinpath(lazy_root, "nvim-treesitter")
local autotag_root = vim.fs.joinpath(lazy_root, "nvim-ts-autotag")

local function fail(message)
	error(message, 0)
end

local function assert_equal(actual, expected, message)
	if not vim.deep_equal(actual, expected) then
		fail(string.format("%s\nexpected: %s\nactual:   %s", message, vim.inspect(expected), vim.inspect(actual)))
	end
end

local function assert_true(value, message)
	if not value then
		fail(message)
	end
end

local function assert_contains(values, expected, message)
	for _, value in ipairs(values) do
		if value == expected then
			return
		end
	end
	fail(string.format("%s\nmissing: %s\nactual:  %s", message, expected, vim.inspect(values)))
end

local function buffer_map(bufnr, mode, lhs)
	local mappings = vim.api.nvim_buf_get_keymap(bufnr, mode)
	for _, mapping in ipairs(mappings) do
		if
			vim.api.nvim_replace_termcodes(mapping.lhs, true, true, true)
			== vim.api.nvim_replace_termcodes(lhs, true, true, true)
		then
			return mapping
		end
	end
	fail(string.format("missing %s-mode mapping %s: %s", mode, lhs, vim.inspect(mappings)))
end

local function selection_range()
	local start = vim.fn.getpos("v")
	local finish = vim.fn.getpos(".")
	if start[2] > finish[2] or (start[2] == finish[2] and start[3] > finish[3]) then
		start, finish = finish, start
	end
	return { start[2], start[3], finish[2], finish[3] }
end

local function new_buffer(filetype, lines)
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_current_buf(bufnr)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	vim.bo[bufnr].buftype = ""
	vim.bo[bufnr].filetype = filetype
	return bufnr
end

local function source_plugin_files(root)
	for _, path in ipairs(vim.fn.glob(vim.fs.joinpath(root, "plugin", "*.lua"), false, true)) do
		dofile(path)
	end
end

assert_true(vim.fn.isdirectory(treesitter_root) == 1, "nvim-treesitter is not installed under stdpath('data')/lazy")
vim.opt.runtimepath:prepend(nvim_root)
vim.opt.runtimepath:prepend(treesitter_root)
vim.opt.runtimepath:prepend(autotag_root)

source_plugin_files(autotag_root)
source_plugin_files(treesitter_root)
local spec = dofile(vim.fs.joinpath(nvim_root, "lua", "psm", "plugins", "treesitter.lua"))
assert_true(type(spec.config) == "function", "treesitter plugin spec must expose config()")
for _, dependency in ipairs(spec.dependencies or {}) do
	if type(dependency) == "table" and dependency[1] == "windwp/nvim-ts-autotag" and dependency.opts then
		require("nvim-ts-autotag").setup(dependency.opts)
	end
end
spec.config()
dofile(vim.fs.joinpath(nvim_root, "lua", "psm", "core", "options.lua"))

local installed_parsers = {
	"bash",
	"c",
	"css",
	"dockerfile",
	"gitignore",
	"go",
	"gomod",
	"gosum",
	"gowork",
	"html",
	"javascript",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"prisma",
	"python",
	"query",
	"rust",
	"svelte",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
}
for _, language in ipairs(installed_parsers) do
	local ok, loaded = pcall(vim.treesitter.language.add, language)
	assert_true(ok and loaded, string.format("Treesitter parser %s is unavailable", language))
end

local lua_buf = new_buffer("lua", {
	"local function answer()",
	'print("treesitter")',
	"end",
})
assert_true(
	vim.wait(1000, function()
		return vim.treesitter.highlighter.active[lua_buf] ~= nil
	end),
	"Lua Treesitter highlighting did not start"
)
assert_true(vim.bo[lua_buf].indentexpr ~= "", "Lua Treesitter indentation is not configured")
vim.cmd("normal! gg=G")
assert_equal(vim.api.nvim_buf_get_lines(lua_buf, 0, -1, false), {
	"local function answer()",
	'  print("treesitter")',
	"end",
}, "Lua Treesitter indentation changed")

vim.api.nvim_buf_set_lines(lua_buf, 0, -1, false, { "local answer = foo(1 + 2)" })
vim.api.nvim_win_set_cursor(0, { 1, 19 })
local start_selection = buffer_map(lua_buf, "n", "<leader>v")
local grow_selection = buffer_map(lua_buf, "x", "<leader>v")
local shrink_selection = buffer_map(lua_buf, "x", "<BS>")
assert_true(type(start_selection.callback) == "function", "normal-mode <leader>v must be a Lua mapping")
assert_true(type(grow_selection.callback) == "function", "visual-mode <leader>v must be a Lua mapping")
assert_true(type(shrink_selection.callback) == "function", "visual-mode <BS> must be a Lua mapping")
vim.api.nvim_feedkeys(" v", "mx", false)
local selected_node = selection_range()
assert_equal(
	selected_node,
	{ 1, 20, 1, 20 },
	"initial Treesitter selection no longer selects the number under the cursor"
)
vim.api.nvim_feedkeys(" v", "mx", false)
local selected_parent = selection_range()
assert_equal(selected_parent, { 1, 20, 1, 24 }, "<leader>v no longer expands to the surrounding expression")
require("psm.core.treesitter").refresh()
shrink_selection.callback()
assert_equal(selection_range(), selected_node, "<BS> must restore the previous selection even after a parser refresh")
shrink_selection.callback()
assert_equal(selection_range(), selected_node, "<BS> must be a no-op at the first Treesitter selection")

-- An empty parser root is not a selectable range.
vim.cmd("normal! \27")
vim.api.nvim_buf_set_lines(lua_buf, 0, -1, false, { "" })
start_selection.callback()
assert_equal(vim.fn.mode(), "n", "selecting an empty file must leave Normal mode intact")

vim.api.nvim_buf_set_lines(lua_buf, 0, -1, false, { "local answer = foo(1 + 2)" })
vim.api.nvim_win_set_cursor(0, { 1, 19 })
start_selection.callback()
grow_selection.callback()
vim.cmd("normal! h")
local manual_range = selection_range()
shrink_selection.callback()
assert_equal(selection_range(), manual_range, "manual selection changes must invalidate the old history")

vim.cmd("normal! \27")
vim.api.nvim_win_set_cursor(0, { 1, 19 })
start_selection.callback()
grow_selection.callback()
vim.api.nvim_buf_set_lines(lua_buf, 0, -1, false, { "local answer = foo(1 + 3)" })
local edited_range = selection_range()
shrink_selection.callback()
assert_equal(selection_range(), edited_range, "edits must invalidate selection history")

vim.cmd("normal! \27")
local bash_buf = new_buffer("bash", {
	"if true; then",
	"echo treesitter",
	"fi",
})
vim.wait(50)
assert_equal(vim.treesitter.highlighter.active[bash_buf], nil, "Bash must remain excluded from Treesitter highlighting")
assert_true(vim.bo[bash_buf].indentexpr ~= "", "Bash Treesitter indentation must remain enabled")
vim.cmd("normal! gg=G")
assert_equal(vim.api.nvim_buf_get_lines(bash_buf, 0, -1, false), {
	"if true; then",
	"  echo treesitter",
	"fi",
}, "Bash Treesitter indentation changed")

local markdown_buf = new_buffer("markdown", {
	"---",
	"title: smoke",
	"---",
	"",
	"```lua",
	"local injected = true",
	"```",
	"",
	"<span>html</span>",
	"",
	"plain *markdown* text",
})
local markdown_parser = assert(vim.treesitter.get_parser(markdown_buf), "Markdown parser is unavailable")
markdown_parser:parse(true)
local languages = {}
markdown_parser:for_each_tree(function(_, language_tree)
	table.insert(languages, language_tree:lang())
end)
assert_contains(languages, "markdown", "Markdown root tree was not parsed")
assert_contains(languages, "markdown_inline", "Markdown inline injection was not parsed")
assert_contains(languages, "yaml", "Markdown YAML metadata injection was not parsed")
assert_contains(languages, "lua", "Markdown fenced Lua injection was not parsed")
assert_contains(languages, "html", "Markdown HTML block injection was not parsed")
assert_equal(vim.wo.foldmethod, "manual", "Markdown folds must remain manual")

local html_buf = new_buffer("html", { "" })
local close_tag = buffer_map(html_buf, "i", ">")
assert_true(type(close_tag.callback) == "function", "nvim-ts-autotag did not install its > mapping")
local tag_keys = vim.api.nvim_replace_termcodes("i<div><Esc>", true, false, true)
vim.api.nvim_feedkeys(tag_keys, "mx", false)
assert_equal(vim.api.nvim_get_current_line(), "<div></div>", "HTML tag auto-closing changed")

local real_get_parser = vim.treesitter.get_parser
vim.treesitter.get_parser = function(bufnr, ...)
	if bufnr == html_buf then
		return nil
	end
	return real_get_parser(bufnr, ...)
end
vim.api.nvim_exec_autocmds("FileType", { buffer = html_buf, modeline = false })
vim.treesitter.get_parser = real_get_parser
assert_equal(vim.wo.foldmethod, "manual", "an allowed filetype without a parser must use manual folds")
assert_equal(vim.wo.foldexpr, "0", "a buffer without a parser must not use Treesitter foldexpr")

vim.api.nvim_set_current_buf(lua_buf)
vim.api.nvim_exec_autocmds("FileType", { buffer = lua_buf, modeline = false })
local first_lua_window = vim.api.nvim_get_current_win()
vim.cmd("vsplit")
local second_lua_window = vim.api.nvim_get_current_win()
vim.api.nvim_exec_autocmds("FileType", { buffer = lua_buf, modeline = false })
for _, window in ipairs({ first_lua_window, second_lua_window }) do
	assert_equal(
		vim.api.nvim_get_option_value("foldmethod", { win = window }),
		"expr",
		"Lua must use Treesitter folds in every window"
	)
	assert_equal(
		vim.api.nvim_get_option_value("foldexpr", { win = window }),
		"v:lua.vim.treesitter.foldexpr()",
		"Lua foldexpr changed"
	)
end
vim.api.nvim_win_close(second_lua_window, true)

local special_buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_set_current_buf(special_buf)
vim.api.nvim_buf_set_lines(special_buf, 0, -1, false, { "local ignored = true" })
vim.bo[special_buf].filetype = "lua"
assert_equal(
	vim.treesitter.highlighter.active[special_buf],
	nil,
	"special buffers must not start Treesitter highlighting"
)
assert_equal(vim.wo.foldmethod, "manual", "special buffers must keep manual folds")
assert_equal(vim.api.nvim_buf_get_keymap(special_buf, "n"), {}, "special buffers must not receive Treesitter mappings")

local cold_buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_set_current_buf(cold_buf)
vim.api.nvim_buf_set_lines(cold_buf, 0, -1, false, { '{ "ready": true }' })
vim.bo[cold_buf].buftype = ""
vim.treesitter.get_parser = function(bufnr, ...)
	if bufnr == cold_buf then
		return nil
	end
	return real_get_parser(bufnr, ...)
end
vim.bo[cold_buf].filetype = "json"
vim.treesitter.get_parser = real_get_parser
assert_equal(vim.treesitter.highlighter.active[cold_buf], nil, "a buffer without its parser must stay unattached")
require("psm.core.treesitter").refresh()
assert_true(
	vim.wait(1000, function()
		return vim.treesitter.highlighter.active[cold_buf] ~= nil
	end),
	"refresh did not attach a parser that became available after FileType"
)
assert_equal(vim.wo.foldmethod, "expr", "refresh did not enable folds after a parser became available")

print(
	string.format(
		"treesitter smoke: ok (selection %s -> %s -> %s)",
		vim.inspect(selected_node),
		vim.inspect(selected_parent),
		vim.inspect(selected_node)
	)
)
