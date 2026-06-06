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

return M
