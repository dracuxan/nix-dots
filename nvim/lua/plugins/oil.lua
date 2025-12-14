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
				float = {
					padding = 2,
					max_width = 0.8,
					max_height = 0.8,
					border = "rounded",
					win_options = {
						winblend = 0,
					},
				},
				confirmation = {
					border = "rounded",
				},
			})

			vim.keymap.set("n", "<space>-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
			vim.keymap.set("n", "-", require("oil").toggle_float)
		end,
	},

	{
		"benomahony/oil-git.nvim",
		dependencies = { "stevearc/oil.nvim" },
	},
}
