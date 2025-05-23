local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	return
end

toggleterm.setup({
	size = function(term)
		if term.direction == "horizontal" then
			return 15
		else
			return 60
		end
	end,
	open_mapping = [[<M-\>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "vertical",
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
		winblend = 0,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
})

function _G.set_terminal_keymaps()
	local opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
local Terminal = require("toggleterm.terminal").Terminal

-- Define toggle functions

function _RUN_SCRIPT()
	-- Get the current buffer name (full path)
	local bufname = vim.api.nvim_buf_get_name(0)

	if bufname == "" then
		print("No file detected!")
		return
	end

	-- Extract the filename without extension
	local filename = vim.fn.fnamemodify(bufname, ":t:r") -- ":t" = tail (filename), ":r" = remove extension

	-- Create a terminal instance with the dynamic command
	local script_term = Terminal:new({
		cmd = "run.sh " .. filename,
		direction = "horizontal",
		hidden = true,
		close_on_exit = false,
	})

	script_term:toggle()
end

function _MAKE_RUN()
	local make = Terminal:new({ cmd = "make run", hidden = true, direction = "horizontal", close_on_exit = false })
	make:toggle()
end

function _MAKE_TEST()
	local make = Terminal:new({ cmd = "make test", direction = "horizontal", hidden = true, close_on_exit = false })
	make:toggle()
end

function _MAKE_BENCH()
	local make = Terminal:new({ cmd = "make bench", hidden = true, direction = "horizontal", close_on_exit = false })
	make:toggle()
end

function _MAKE_BUILD()
	local make = Terminal:new({ cmd = "make build", hidden = true, direction = "horizontal", close_on_exit = false })
	make:toggle()
end

function _MAKE_CLEAN()
	local make = Terminal:new({ cmd = "make clean", hidden = true, direction = "horizontal", close_on_exit = false })
	make:toggle()
end

function _LAZYGIT_TOGGLE()
	local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

	lazygit:toggle()
end

-- Set keymaps
vim.keymap.set("n", "<M-m>sr", _RUN_SCRIPT, { noremap = true, silent = true, desc = "use run script" })
vim.keymap.set("n", "<M-m>r", _MAKE_RUN, { noremap = true, silent = true, desc = "make run" })
vim.keymap.set("n", "<M-m>t", _MAKE_TEST, { noremap = true, silent = true, desc = "make test" })
vim.keymap.set("n", "<M-m>b", _MAKE_BUILD, { noremap = true, silent = true, desc = "make build" })
vim.keymap.set("n", "<M-m>B", _MAKE_BENCH, { noremap = true, silent = true, desc = "make bench" })
vim.keymap.set("n", "<M-m>c", _MAKE_CLEAN, { noremap = true, silent = true, desc = "make clean" })
vim.keymap.set("n", "<M-m>l", _LAZYGIT_TOGGLE, { noremap = true, silent = true, desc = "lazygit" })
