vim.g.mapleader = " "
vim.g.maplocalleader = ","

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "jk로 입력 모드 종료" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "검색 하이라이트 지우기" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "숫자 증가" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "숫자 감소" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "세로 분할" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "가로 분할" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "분할 크기 같게 맞추기" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "현재 분할 닫기" }) -- close current split window

-- indent
-- keymap.set("v", "<", "<gv", { desc = "indent to right" })
-- keymap.set("v", "<", ">gv", { desc = "indent to left" })
