local M = {}

-- Keep markdown injections on the Neovim 0.12 runtime query path and avoid
-- snacks.nvim's extending query from breaking injected code fence parsing.
vim.treesitter.query.set(
	"markdown",
	"injections",
	[[
(fenced_code_block
  (info_string
    (language) @_lang)
  (#eq? @_lang "math")
  (code_fence_content) @injection.content
  (#set! injection.language "latex"))

(fenced_code_block
  (info_string
    (language) @injection.language)
  (code_fence_content) @injection.content)

((html_block) @injection.content
  (#set! injection.language "html")
  (#set! injection.combined)
  (#set! injection.include-children))

((minus_metadata) @injection.content
  (#set! injection.language "yaml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

((plus_metadata) @injection.content
  (#set! injection.language "toml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

([
  (inline)
  (pipe_table_cell)
] @injection.content
  (#set! injection.language "markdown_inline"))
]]
)

local fold_filetypes = {
	c = true,
	css = true,
	dockerfile = true,
	go = true,
	gomod = true,
	gosum = true,
	gowork = true,
	html = true,
	json = true,
	lua = true,
	python = true,
	rust = true,
	vim = true,
	yaml = true,
}

local indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

local function parser_for(buf)
	if vim.bo[buf].buftype == "" and vim.bo[buf].filetype ~= "" then
		return vim.treesitter.get_parser(buf)
	end
end

local function folds(win)
	local buf = vim.api.nvim_win_get_buf(win)
	local enabled = fold_filetypes[vim.bo[buf].filetype] and parser_for(buf) ~= nil
	vim.wo[win][0].foldmethod = enabled and "expr" or "manual"
	vim.wo[win][0].foldexpr = enabled and "v:lua.vim.treesitter.foldexpr()" or "0"
end

function M.attach(buf)
	local selection = require("psm.core.treesitter_selection")
	local parser = parser_for(buf)
	local lang = parser and parser:lang()
	if vim.b[buf].psm_ts_attached and vim.b[buf].psm_ts_attached ~= lang then
		vim.treesitter.stop(buf)
		selection.detach(buf)
		if vim.bo[buf].indentexpr == indentexpr then
			vim.bo[buf].indentexpr = ""
		end
	end
	vim.b[buf].psm_ts_attached = lang
	if not parser then
		return
	end

	if lang ~= "bash" and vim.treesitter.query.get(lang, "highlights") then
		vim.treesitter.start(buf)
	else
		vim.treesitter.stop(buf)
	end
	if vim.treesitter.query.get(lang, "indents") then
		vim.bo[buf].indentexpr = indentexpr
	elseif vim.bo[buf].indentexpr == indentexpr then
		vim.bo[buf].indentexpr = ""
	end
	selection.attach(buf)
end

function M.refresh()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) then
			M.attach(buf)
		end
	end
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		folds(win)
	end
end

function M.setup()
	local group = vim.api.nvim_create_augroup("PsmTreesitter", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		callback = function(args)
			M.attach(args.buf)
			for _, win in ipairs(vim.fn.win_findbuf(args.buf)) do
				folds(win)
			end
		end,
	})
	vim.api.nvim_create_autocmd("BufWinEnter", {
		group = group,
		callback = function()
			folds(vim.api.nvim_get_current_win())
		end,
	})
end

return M
