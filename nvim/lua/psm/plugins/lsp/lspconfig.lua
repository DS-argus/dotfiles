return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local lsp_group = vim.api.nvim_create_augroup("PsmLspAttach", { clear = true })
		local python_root_markers = {
			"pyrightconfig.json",
			"pyproject.toml",
			"uv.lock",
			"setup.py",
			"setup.cfg",
			"requirements.txt",
			"Pipfile",
			".git",
		}

		local function find_python_path(startpath)
			local search_from = startpath or vim.uv.cwd()
			if not search_from or search_from == "" then
				return nil
			end

			local venv_dir = vim.fs.find(".venv", {
				path = search_from,
				upward = true,
				type = "directory",
				limit = 1,
			})[1]

			if venv_dir then
				local python_path = vim.fs.joinpath(venv_dir, "bin", "python")
				if vim.fn.executable(python_path) == 1 then
					return python_path
				end
			end

			if vim.env.VIRTUAL_ENV then
				local active_python = vim.fs.joinpath(vim.env.VIRTUAL_ENV, "bin", "python")
				if vim.fn.executable(active_python) == 1 then
					return active_python
				end
			end

			for _, executable in ipairs({ "python3", "python" }) do
				local python_path = vim.fn.exepath(executable)
				if python_path ~= "" then
					return python_path
				end
			end

			return nil
		end

		local function with_pyright_python_path(settings, python_path)
			if not python_path or python_path == "" then
				return settings
			end

			return vim.tbl_deep_extend("force", settings or {}, {
				python = { pythonPath = python_path },
			})
		end

		local function update_pyright_python_path(client, python_path)
			if not python_path or python_path == "" then
				return
			end

			local runtime_path = client.settings
				and client.settings.python
				and client.settings.python.pythonPath
			local current_path = client.config.settings
				and client.config.settings.python
				and client.config.settings.python.pythonPath

			if runtime_path == python_path and current_path == python_path then
				return
			end

			client.settings = with_pyright_python_path(client.settings, python_path)
			client.config.settings = with_pyright_python_path(client.config.settings, python_path)

			if client.workspace_did_change_configuration then
				client.workspace_did_change_configuration(client.settings)
			else
				client:notify("workspace/didChangeConfiguration", { settings = client.settings })
			end
		end

		vim.api.nvim_create_autocmd("LspAttach", {
			group = lsp_group,
			callback = function(args)
				local client = args.data and vim.lsp.get_client_by_id(args.data.client_id) or nil

				if client and client.name == "pyright" then
					local bufname = vim.api.nvim_buf_get_name(args.buf)
					local startpath = bufname ~= "" and vim.fs.dirname(bufname) or client.config.root_dir
					update_pyright_python_path(client, find_python_path(startpath))
				end

				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, {
						buffer = args.buf,
						silent = true,
						desc = desc,
					})
				end

					map("n", "gd", vim.lsp.buf.definition, "정의로 이동")
					map("n", "gD", vim.lsp.buf.declaration, "선언으로 이동")
					map("n", "gR", vim.lsp.buf.references, "참조 보기")
					map("n", "K", vim.lsp.buf.hover, "호버 문서 보기")
					map("n", "<leader>rn", vim.lsp.buf.rename, "심볼 이름 바꾸기")
					map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "코드 액션")
					map("n", "<leader>ld", vim.diagnostic.open_float, "줄 진단 보기")
					map("n", "<leader>ls", vim.lsp.buf.document_symbol, "문서 심볼 보기")
				end,
			})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		-- for type, icon in pairs(signs) do
		-- 	local hl = "DiagnosticSign" .. type
		-- 	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		-- end

		-- 최신 권장 방식
		vim.diagnostic.config({
			signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = " ",
				[vim.diagnostic.severity.WARN]  = " ",
				[vim.diagnostic.severity.HINT]  = "󰠠 ",
				[vim.diagnostic.severity.INFO]  = " ",
			},
			},
		})

		-- LSP 서버 목록 (mason.lua와 동일하게 유지)
		local servers = { "pyright", "lua_ls", "rust_analyzer" } -- CSS도 제거

		-- Neovim 0.11+ 방식: 서버별 설정을 등록하고, 필요한 서버만 명시적으로 활성화한다.
		for _, server in ipairs(servers) do
			local opts = { capabilities = capabilities }
			if server == "lua_ls" then
				opts.settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						completion = { callSnippet = "Replace" },
						workspace = {
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
							},
							maxPreload = 100000,
							preloadFileSize = 10000,
						},
					},
				}
			end
			if server == "pyright" then
				opts.root_markers = python_root_markers
				opts.on_new_config = function(new_config, root_dir)
					new_config.settings = with_pyright_python_path(new_config.settings, find_python_path(root_dir))
				end
				opts.settings = {
					python = {
						analysis = {
							typeCheckingMode = "basic",             -- 기본 타입 체크 활성화
							diagnosticMode = "workspace",           -- 프로젝트 전체 진단
							autoSearchPaths = true,                 -- 일반적인 src/패키지 구조 자동 탐색
							useLibraryCodeForTypes = true,          -- 라이브러리 타입 추론 강화
							exclude = { "venv", ".venv", "__pycache__", "*.pyc" }, -- 캐시 파일도 제외
						},
					},
				}
			end
			vim.lsp.config(server, opts)
			vim.lsp.enable(server)
		end
	end,
}
