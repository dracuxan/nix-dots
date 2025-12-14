local vim = vim
local vk = vim.keymap.set
-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- For conciseness
local opts = { noremap = true, silent = true }

-- Custom
-- Exit to normal mode
vk("i", "jj", "<Esc>", opts)

-- Navigation in insert mode
vk("i", "<C-h>", "<Left>", opts)
vk("i", "<C-l>", "<Right>", opts)
vk("i", "<C-j>", "<Down>", opts)
vk("i", "<C-k>", "<Up>", opts)

vk("i", "<C-b>", "<C-o>^", opts) -- Move to start of line
vk("i", "<C-e>", "<C-o>$", opts) -- Move to end of line

-- Disable the spacebar key's default behavior in Normal and Visual modes
vk({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- save file
vk("n", "<C-s>", "<cmd> w <CR>", opts)
vk("i", "<C-s>", "<Esc><cmd> w <CR>", opts)
vk("n", "<M-a>", "<cmd> AutoSession search <CR>", opts)

-- delete single character without copying into register
vk("n", "x", '"_x', opts)

-- Resize with arrows
vk("n", "<Up>", ":resize -2<CR>", opts)
vk("n", "<Down>", ":resize +2<CR>", opts)
vk("n", "<Left>", ":vertical resize -2<CR>", opts)
vk("n", "<Right>", ":vertical resize +2<CR>", opts)

-- Buffers
vk("n", "<Tab>", ":bnext<CR>", opts)
vk("n", "<S-Tab>", ":bprevious<CR>", opts)
vk("n", "<leader>x", ":bdelete!<CR>", opts) -- close buffer
vk("n", "<leader>x", function()
	local bufnr = vim.api.nvim_get_current_buf() -- Get the current buffer number
	local buffers = vim.fn.getbufinfo({ buflisted = 1 }) -- Get list of open buffers

	if #buffers > 1 then
		vim.cmd("bnext") -- Switch to the next buffer
	else
		vim.cmd("enew") -- Open a new empty buffer if it's the last one
	end

	vim.cmd("bdelete! " .. bufnr) -- Delete the previous buffer
end, opts)

-- Navigate between splits
vk("n", "<C-k>", ":wincmd k<CR>", opts)
vk("n", "<C-j>", ":wincmd j<CR>", opts)
vk("n", "<C-h>", ":wincmd h<CR>", opts)
vk("n", "<C-l>", ":wincmd l<CR>", opts)

-- Toggle line wrapping
-- vk("n", "<leader>lw", "<cmd>set wrap!<CR>", opts)

-- Stay in indent mode
vk("v", "<", "<gv", opts)
vk("v", ">", ">gv", opts)

-- Keep last yanked when pasting
vk("v", "p", '"_dP', opts)

-- Diagnostic keymaps
vk("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vk("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Reload Config
local new_opts = { desc = "Reload current Lua file", noremap = true, silent = true }

vk("n", "<leader>rr", ":luafile %<CR>", new_opts)

-- Open Lazy Plugin Manager
vk("n", "<leader>l", "<cmd>Lazy<CR>", opts)

-- Quit all
vk("n", "<C-q>", "<cmd> qa <CR>", opts)
vk("i", "<C-q>", "<cmd> qa <CR>", opts)

-- Quit
vk("n", "qq", "<cmd> q <CR>", opts)

-- Find todos using fzf
vk("n", "<leader>ft", "<cmd> TodoFzfLua <CR>", { desc = "[F]ind [T]odos using fzf", noremap = true, silent = true })

-- Manual file reload control
vk("n", "<leader>fr", ":checktime<CR>", { desc = "Check external file changes" })
vk("n", "<leader>fr!", ":edit!<CR>", { desc = "Force reload file" })

-- For terminal navigation
vk("t", "<C-h>", [[<C-\><C-N><C-w>h]])
vk("t", "<C-j>", [[<C-\><C-N><C-w>j]])
vk("t", "<C-k>", [[<C-\><C-N><C-w>k]])
vk("t", "<C-l>", [[<C-\><C-N><C-w>l]])
