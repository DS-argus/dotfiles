-- WezTerm 메인 엔트리 파일.
-- 실제 설정은 역할별 모듈로 나누고 여기서는 로드만
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- 수동으로 attach해서 쓰는 로컬 persistent mux domain.
config.unix_domains = {
	{
		name = "unix",
	},
}

-- 화면/스타일 관련 설정
require("ui").apply(config, wezterm)
-- 키맵, workspace, pane 이동 관련 설정
require("keymap").apply(config, wezterm)

return config
