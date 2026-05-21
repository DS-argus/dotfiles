return {
	"kylechui/nvim-surround",
	event = { "BufReadPre", "BufNewFile" },
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	config = true,

	-- ys{motion}{char} : Add
	-- ds{char} : Delete
	-- cs{target}{replacement} : Change
}
