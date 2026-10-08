local M = {}

local function setup_diagnostics()
	vim.diagnostic.config({
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = " ",
				[vim.diagnostic.severity.WARN] = " ",
				[vim.diagnostic.severity.HINT] = "󰠠 ",
				[vim.diagnostic.severity.INFO] = " ",
			},
		},
		-- <leader>ld(open_float) 창. 테두리는 hover/cmp/mason과 같은 double로 맞추고,
		-- "Diagnostics:" 헤더는 숨기며, 버퍼에 진단 출처가 둘 이상일 때만 [ty]/[Ruff] 같은 출처를 붙인다.
		float = { border = "double", header = "", source = "if_many" },
	})
end

local function setup_lsp_attach()
	local group = vim.api.nvim_create_augroup("PsmLspAttach", { clear = true })

	vim.api.nvim_create_autocmd("LspAttach", {
		group = group,
		callback = function(args)
			local client = args.data and vim.lsp.get_client_by_id(args.data.client_id) or nil

			if client then
				require("psm.lsp.servers").on_attach(args, client)
			end

			require("psm.lsp.keymaps").on_attach(args)
		end,
	})
end

function M.setup()
	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	local servers = require("psm.lsp.servers")

	setup_lsp_attach()
	setup_diagnostics()

	-- server name별로 설정파일 로드
	for _, server in ipairs(servers.names) do
		vim.lsp.config(server, servers.opts(server, capabilities))
		vim.lsp.enable(server)
	end
end

return M
