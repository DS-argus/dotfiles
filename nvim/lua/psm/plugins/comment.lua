return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    -- import comment plugin safely
    local comment = require("Comment")
    local ft = require("Comment.ft")
    local calculate = ft.calculate

    -- Neovim 0.12 returns nil when no parser is available.
    ft.calculate = function(ctx)
      local ok, parser = pcall(vim.treesitter.get_parser, 0)
      if not ok or not parser then
        return ft.get(vim.bo.filetype, ctx.ctype)
      end
      return calculate(ctx)
    end

    local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

    -- enable comment
    comment.setup({
      -- for commenting tsx, jsx, svelte, html files
      pre_hook = ts_context_commentstring.create_pre_hook(),
    })
  end,
}
