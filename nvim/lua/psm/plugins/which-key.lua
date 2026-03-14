return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    spec = {
      { "<leader>c", group = "코드" },
      { "<leader>e", group = "탐색기" },
      { "<leader>f", group = "찾기" },
      { "<leader>g", group = "깃" },
      { "<leader>l", group = "린트/LSP" },
      { "<leader>m", group = "포맷/마크다운" },
      { "<leader>n", group = "알림" },
      { "<leader>r", group = "이름 변경" },
      { "<leader>s", group = "창/치환" },
      { "<leader>t", group = "탭" },
      { "<leader>x", group = "문제" },
    },
  },
}
