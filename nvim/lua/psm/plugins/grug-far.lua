local function current_file_path()
	local path = vim.fn.expand("%")
	if path == "" then
		return nil
	end

	return vim.fn.fnameescape(path)
end

local function focus_replacement_input(instance)
	if not instance or type(instance.when_ready) ~= "function" then
		return
	end

	instance:when_ready(function()
		if type(instance.goto_input) == "function" then
			instance:goto_input("replacement")
		end
	end)
end

local function current_file_prefills()
	local prefills = {}
	local path = current_file_path()

	if path then
		prefills.paths = path
	end

	return prefills
end

local function open_current_file_replace()
	local grug_far = require("grug-far")
	local prefills = current_file_prefills()
	local cword = vim.fn.expand("<cword>")

	if cword ~= "" then
		prefills.search = cword
	end

	local instance = grug_far.open({
		prefills = prefills,
	})

	focus_replacement_input(instance)
end

local function open_current_file_replace_with_selection()
	local instance = require("grug-far").with_visual_selection({
		prefills = current_file_prefills(),
	})

	focus_replacement_input(instance)
end

return {
	"MagicDuck/grug-far.nvim",
	cmd = { "GrugFar", "GrugFarWithin" },
	opts = {
		transient = true,
	},
	config = function(_, opts)
		require("grug-far").setup(opts)
	end,
	keys = {
		{
			"<leader>sr",
			function()
				open_current_file_replace()
			end,
			mode = "n",
			desc = "현재 파일 찾기/바꾸기",
		},
		{
			"<leader>sr",
			function()
				open_current_file_replace_with_selection()
			end,
			mode = "x",
			desc = "현재 파일 찾기/바꾸기",
		},
	},
}
