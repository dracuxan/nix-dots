local vim = vim
return {
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			CustomOilBar = function()
				local path = vim.fn.expand("%")
				path = path:gsub("oil://", "")

				return "  " .. vim.fn.fnamemodify(path, ":.")
			end
			vim.cmd([[
  hi NormalFloat guibg=NONE
  hi FloatBorder guibg=NONE
  hi OilNormal guibg=NONE
  hi OilFloat guibg=NONE
]])

			require("oil").setup({
				columns = { "icon" },
				keymaps = {
					["<C-h>"] = false,
					["<C-l>"] = false,
					["<C-k>"] = false,
					["<C-j>"] = false,
					["<M-h>"] = "actions.select_split",
				},
				view_options = {
					show_hidden = true,
					is_always_hidden = function(name, _)
						local folder_skip = { "dev-tools.locks", "dune.lock", "_build" }
						return vim.tbl_contains(folder_skip, name)
					end,
				},
			})

			-- Open parent directory in current window
			vim.keymap.set("n", "<space>-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
			-- vim.keymap.set("n", "-", function()
			-- 	-- Open vertical split on the right
			-- 	vim.cmd("vsplit | wincmd l")
			-- 	-- Resize it to 10% of total columns
			-- 	vim.cmd("vertical resize " .. math.floor(vim.o.columns / 4))
			-- 	-- Open oil in the new window
			-- 	require("oil").open()
			-- end)
			-- Open parent directory in floating window
			vim.keymap.set("n", "-", require("oil").toggle_float)
		end,
	},
}
