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

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "새 탭 열기" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "현재 탭 닫기" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "다음 탭으로 이동" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "이전 탭으로 이동" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "현재 버퍼를 새 탭에서 열기" }) --  move current buffer to new tab

-- indent
-- keymap.set("v", "<", "<gv", { desc = "indent to right" })
-- keymap.set("v", "<", ">gv", { desc = "indent to left" })
