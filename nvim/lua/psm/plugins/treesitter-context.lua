-- 스크롤해도 현재 함수/클래스 시그니처를 창 상단에 고정해서 보여준다.
return {
	"nvim-treesitter/nvim-treesitter-context",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		max_lines = 3, -- 상단에 고정할 최대 줄 수
		multiline_threshold = 1, -- 여러 줄짜리 시그니처는 첫 줄만 표시
		trim_scope = "outer", -- max_lines를 넘으면 바깥쪽 scope부터 생략
	},
	keys = {
		{ "<leader>tc", "<cmd>TSContext toggle<CR>", desc = "코드 컨텍스트 표시 토글" },
		{
			"[x",
			function()
				require("treesitter-context").go_to_context(vim.v.count1)
			end,
			desc = "현재 컨텍스트 시작으로 이동",
		},
	},
}
