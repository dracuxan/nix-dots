local vim = vim
local autoRun = "horizontal"
local default = "vertical"
local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	return
end

toggleterm.setup({
	size = function(term)
		if term.direction == "horizontal" then
			return 20
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
	direction = default,
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
	local opts = { noremap = true }
	vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
local Terminal = require("toggleterm.terminal").Terminal

-- Define toggle functions

function _RUN_SCRIPT()
	local buffname = vim.api.nvim_buf_get_name(0)
	local filepath = vim.fn.fnamemodify(buffname, ":p")
	local script_run = Terminal:new({
		cmd = "run.sh " .. filepath,
		hidden = true,
		close_on_exit = false,
		direction = autoRun,
		persist_size = true,
	})

	script_run:toggle()
end

function _RUN_TEST()
	local buffname = vim.api.nvim_buf_get_name(0)
	local filepath = vim.fn.fnamemodify(buffname, ":p")
	local script_test = Terminal:new({
		cmd = "run.sh " .. filepath .. " --test",
		direction = autoRun,
		persist_size = true,
		hidden = true,
		close_on_exit = false,
	})
	script_test:toggle()
end

function _RUN_REPL()
	local buffname = vim.api.nvim_buf_get_name(0)
	local filepath = vim.fn.fnamemodify(buffname, ":p")
	local script_test = Terminal:new({
		cmd = "run.sh " .. filepath .. " --repl",
		direction = autoRun,
		persist_size = true,
		hidden = true,
		close_on_exit = false,
	})
	script_test:toggle()
end

function _RUN_BUILD()
	local buffname = vim.api.nvim_buf_get_name(0)
	local filepath = vim.fn.fnamemodify(buffname, ":p")
	local script_build = Terminal:new({
		cmd = "run.sh " .. filepath .. " --build-only",
		hidden = true,
		direction = autoRun,
		persist_size = true,
		close_on_exit = false,
	})
	script_build:toggle()
end

function _SEND_BIN()
	local sendToServer = "run.sh main.go --build-only && scp ./bin/main igris@192.168.0.198:/home/igris/exps"
	local script_send = Terminal:new({
		cmd = sendToServer,
		hidden = true,
		direction = autoRun,
		persist_size = true,
		close_on_exit = false,
	})
	script_send:toggle()
end

function _LAZYGIT_TOGGLE()
	local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

	lazygit:toggle()
end

-- Set keymaps
vim.keymap.set("n", "<M-m>r", _RUN_SCRIPT, { noremap = true, silent = true, desc = "run script" })
vim.keymap.set("n", "<M-m>t", _RUN_TEST, { noremap = true, silent = true, desc = "run test(s)" })
vim.keymap.set("n", "<M-m>i", _RUN_REPL, { noremap = true, silent = true, desc = "run REPL" })
vim.keymap.set("n", "<M-m>b", _RUN_BUILD, { noremap = true, silent = true, desc = "build project" })
vim.keymap.set("n", "<M-m>s", _SEND_BIN, { noremap = true, silent = true, desc = "send binaries to server" })
vim.keymap.set("n", "<M-m>l", _LAZYGIT_TOGGLE, { noremap = true, silent = true, desc = "lazygit" })
