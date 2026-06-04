local M = {}

M.root_markers = {
	"pyrightconfig.json",
	"pyproject.toml",
	"uv.lock",
	"setup.py",
	"setup.cfg",
	"requirements.txt",
	"Pipfile",
	".git",
}

function M.find_python_path(startpath)
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

function M.with_python_path(settings, python_path)
	if not python_path or python_path == "" then
		return settings
	end

	local next_settings = vim.deepcopy(settings or {})
	return M.set_python_path(next_settings, python_path)
end

function M.set_python_path(settings, python_path)
	if not python_path or python_path == "" then
		return settings
	end

	settings = settings or {}
	settings.python = settings.python or {}
	settings.python.pythonPath = python_path

	return settings
end

function M.update_python_path(client, python_path)
	if not python_path or python_path == "" then
		return
	end

	local runtime_path = client.settings and client.settings.python and client.settings.python.pythonPath
	local current_path = client.config.settings
		and client.config.settings.python
		and client.config.settings.python.pythonPath

	if runtime_path == python_path and current_path == python_path then
		return
	end

	client.settings = M.with_python_path(client.settings, python_path)
	client.config.settings = M.with_python_path(client.config.settings, python_path)

	if client.workspace_did_change_configuration then
		client.workspace_did_change_configuration(client.settings)
	else
		client:notify("workspace/didChangeConfiguration", { settings = client.settings })
	end
end

function M.opts()
	return {
		root_markers = M.root_markers,
		before_init = function(_, config)
			config.settings = M.set_python_path(config.settings, M.find_python_path(config.root_dir))
		end,
		settings = {
			python = {
				analysis = {
					typeCheckingMode = "basic", -- 기본 타입 체크 활성화
					diagnosticMode = "workspace", -- 프로젝트 전체 진단
					autoSearchPaths = true, -- 일반적인 src/패키지 구조 자동 탐색
					useLibraryCodeForTypes = true, -- 라이브러리 타입 추론 강화
					exclude = { "venv", ".venv", "__pycache__", "*.pyc" }, -- 캐시 파일도 제외
				},
			},
		},
	}
end

function M.on_attach(args, client)
	local bufname = vim.api.nvim_buf_get_name(args.buf)
	local startpath = bufname ~= "" and vim.fs.dirname(bufname) or client.config.root_dir

	M.update_python_path(client, M.find_python_path(startpath))
end

return M
