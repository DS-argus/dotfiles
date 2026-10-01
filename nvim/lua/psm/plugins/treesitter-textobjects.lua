-- treesitter 구문 단위 text object와 이동
-- 선택: af/if 함수, ac/ic 클래스, aa/ia 인자 (예: vaf, dif, cia)
-- 이동: ]f/[f 함수 시작, ]F/[F 함수 끝, ]C/[C 클래스 시작
return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("nvim-treesitter-textobjects").setup({
			select = {
				lookahead = true, -- 커서가 대상 밖에 있으면 앞쪽의 가장 가까운 대상을 고른다
				selection_modes = {
					["@function.outer"] = "V",
					["@class.outer"] = "V",
				},
			},
			move = {
				set_jumps = true, -- 이동 전 위치를 jumplist에 남겨 <C-o>로 돌아갈 수 있게 한다
			},
		})

		local select = require("nvim-treesitter-textobjects.select")
		local move = require("nvim-treesitter-textobjects.move")

		local function map_select(lhs, query, desc)
			vim.keymap.set({ "x", "o" }, lhs, function()
				select.select_textobject(query, "textobjects")
			end, { desc = desc })
		end

		local function map_move(lhs, fn, query, desc)
			vim.keymap.set({ "n", "x", "o" }, lhs, function()
				move[fn](query, "textobjects")
			end, { desc = desc })
		end

		map_select("af", "@function.outer", "함수 전체")
		map_select("if", "@function.inner", "함수 본문")
		map_select("ac", "@class.outer", "클래스 전체")
		map_select("ic", "@class.inner", "클래스 본문")
		map_select("aa", "@parameter.outer", "인자 (구분자 포함)")
		map_select("ia", "@parameter.inner", "인자")

		map_move("]f", "goto_next_start", "@function.outer", "다음 함수 시작")
		map_move("[f", "goto_previous_start", "@function.outer", "이전 함수 시작")
		map_move("]F", "goto_next_end", "@function.outer", "다음 함수 끝")
		map_move("[F", "goto_previous_end", "@function.outer", "이전 함수 끝")
		map_move("]C", "goto_next_start", "@class.outer", "다음 클래스 시작")
		map_move("[C", "goto_previous_start", "@class.outer", "이전 클래스 시작")
	end,
}
