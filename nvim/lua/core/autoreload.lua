local vim = vim
local M = {}

function M.setup()
	local autoreload_group = vim.api.nvim_create_augroup("AutoReload", { clear = true })

	vim.api.nvim_create_autocmd({
		"FocusGained",
		"CursorHold",
		"CursorHoldI",
	}, {
		group = autoreload_group,
		callback = function()
			if vim.bo.modified == false then
				vim.cmd("checktime")
			end
		end,
	})
end

return M

