local vim = vim
-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- For conciseness
local opts = { noremap = true, silent = true }

-- Custom
-- Exit to normal mode
vim.keymap.set("i", "jj", "<Esc>", opts)

-- Toogle NeoTree
vim.keymap.set("n", "<C-n>", "<cmd>Neotree toggle<CR>", opts)
vim.keymap.set("i", "<C-n>", "<Esc><cmd>Neotree toggle<CR>", opts)

-- Navigation in insert mode
vim.keymap.set("i", "<C-h>", "<Left>", opts)
vim.keymap.set("i", "<C-l>", "<Right>", opts)
vim.keymap.set("i", "<C-j>", "<Down>", opts)
vim.keymap.set("i", "<C-k>", "<Up>", opts)

vim.keymap.set("i", "<C-b>", "<C-o>^", opts) -- Move to start of line
vim.keymap.set("i", "<C-e>", "<C-o>$", opts) -- Move to end of line

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- save file
vim.keymap.set("n", "<C-s>", "<cmd> w <CR>", opts)
vim.keymap.set("i", "<C-s>", "<Esc><cmd> w <CR>", opts)
vim.keymap.set("n", "<C-a>s", "<cmd>noautocmd w <CR>", opts)

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', opts)

-- Resize with arrows
vim.keymap.set("n", "<Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", opts)

-- Buffers
vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)
vim.keymap.set("n", "<leader>x", ":bdelete!<CR>", opts) -- close buffer
vim.keymap.set("n", "<leader>x", function()
	local bufnr = vim.api.nvim_get_current_buf()          -- Get the current buffer number
	local buffers = vim.fn.getbufinfo({ buflisted = 1 })  -- Get list of open buffers

	if #buffers > 1 then
		vim.cmd("bnext") -- Switch to the next buffer
	else
		vim.cmd("enew") -- Open a new empty buffer if it's the last one
	end

	vim.cmd("bdelete! " .. bufnr) -- Delete the previous buffer
end, opts)

-- Window management
-- vim.keymap.set("n", "<leader>v", "<C-w>v", opts) -- split window vertically
-- vim.keymap.set("n", "<leader>h", "<C-w>s", opts) -- split window horizontally
-- vim.keymap.set("n", "<leader>se", "<C-w>=", opts) -- make split windows equal width & height
-- vim.keymap.set("n", "<leader>xs", ":close<CR>", opts) -- close current split window

-- Navigate between splits
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)

-- -- Tabs
-- vim.keymap.set("n", "<leader>to", ":tabnew<CR>", opts) -- open new tab
-- vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", opts) -- close current tab
-- vim.keymap.set("n", "<leader>tn", ":tabn<CR>", opts) --  go to next tab
-- vim.keymap.set("n", "<leader>tp", ":tabp<CR>", opts) --  go to previous tab

-- Toggle line wrapping
-- vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', opts)

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Typing Test
vim.keymap.set("n", "<C-t>", ":Typr<CR>", opts)
vim.keymap.set("n", "<M-t>", ":TyprStat<CR>", opts)

-- Reload Config
local new_opts = { desc = "Reload current Lua file", noremap = true, silent = true }

vim.keymap.set("n", "<leader>rr", ":luafile %<CR>", new_opts)

-- Open Lazy Plugin Manager
vim.keymap.set("n", "<leader>l", "<cmd>Lazy<CR>", opts)

-- Open Alpha
vim.keymap.set("n", "<M-m>a", "<cmd>Alpha<CR>", opts)

-- Quit all
vim.keymap.set("n", "<C-q>", "<cmd> qa <CR>", opts)
vim.keymap.set("i", "<C-q>", "<cmd> qa <CR>", opts)

-- For terminal navigation
vim.keymap.set("t", "<C-h>", [[<C-\><C-N><C-w>h]])
vim.keymap.set("t", "<C-j>", [[<C-\><C-N><C-w>j]])
vim.keymap.set("t", "<C-k>", [[<C-\><C-N><C-w>k]])
vim.keymap.set("t", "<C-l>", [[<C-\><C-N><C-w>l]])
