local M = {}

function M.opts()
	return {
		settings = {
			-- lint 진단만 사용한다. 포맷은 conform(prettier)이 담당하며,
			-- formatter가 없는 svelte/vue/astro에서 저장 시 ESLint 포맷이 끼어들지 않게 끈다.
			format = false,
		},
	}
end

return M
