return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    cmd = { "RenderMarkdown" },
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    main = "render-markdown",
    config = function(_, opts)
      local render_markdown = require("render-markdown")

      render_markdown.setup(opts)

      local group = vim.api.nvim_create_augroup("PsmMarkdownKeymaps", { clear = true })

      local function set_markdown_keymaps(buf)
        vim.keymap.set("n", "<leader>mr", "<cmd>RenderMarkdown buf_toggle<CR>", {
          buffer = buf,
          desc = "Toggle markdown rendering",
        })
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "markdown",
        callback = function(args)
          set_markdown_keymaps(args.buf)
        end,
      })

      if vim.bo.filetype == "markdown" then
        set_markdown_keymaps(vim.api.nvim_get_current_buf())
      end
    end,
    opts = {
      enabled = false,
      preset = "obsidian",
      file_types = { "markdown" },
      completions = {
        lsp = { enabled = true },
      },
    },
  },
}
