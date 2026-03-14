return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
  keys = {
    { "<leader>xx", "<cmd>TroubleToggle<CR>", desc = "문제 목록 토글" },
    { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", desc = "워크스페이스 진단 보기" },
    { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", desc = "현재 파일 진단 보기" },
    { "<leader>xq", "<cmd>TroubleToggle quickfix<CR>", desc = "퀵픽스 목록 보기" },
    { "<leader>xl", "<cmd>TroubleToggle loclist<CR>", desc = "위치 목록 보기" },
    { "<leader>xt", "<cmd>TodoTrouble<CR>", desc = "TODO 목록 보기" },
  },
}
