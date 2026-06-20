vim.g.mapleader = " " -- global prefix
vim.g.maplocalleader = "," -- local prefix

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "jk로 입력 모드 종료" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "검색 하이라이트 지우기" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "숫자 증가" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "숫자 감소" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "세로 분할" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "가로 분할" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "분할 크기 같게 맞추기" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "현재 분할 닫기" }) -- close current split window

-- window navigation (vim-tmux-navigator)
-- C-hjkl은 플러그인 기본 매핑. 윈도우 Alacritty(SSH)가 ctrl+hjkl을 alt+hjkl로 변환해 보내므로
-- tmux 밖 단독 nvim에서도 동작하도록 M-hjkl을 추가 매핑 (tmux 안에서는 tmux가 C-hjkl로 변환해 줌)
keymap.set("n", "<M-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "왼쪽 창으로 이동" })
keymap.set("n", "<M-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "아래 창으로 이동" })
keymap.set("n", "<M-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "위 창으로 이동" })
keymap.set("n", "<M-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "오른쪽 창으로 이동" })

-- tab management
keymap.set("n", "<leader>tn", "<cmd>tabnext<CR>", { desc = "다음 탭" })
keymap.set("n", "<leader>tp", "<cmd>tabprevious<CR>", { desc = "이전 탭" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "현재 탭 닫기" })
