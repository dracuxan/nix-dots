local vim = vim

-- Line numbers and display
vim.wo.number = true
vim.o.relativenumber = true
vim.wo.signcolumn = "yes"
vim.o.numberwidth = 2
vim.o.cursorline = false

-- Text wrapping and navigation
vim.o.wrap = true
vim.o.linebreak = true
vim.o.whichwrap = "bs<>[]hl"
vim.o.scrolloff = 0
vim.o.sidescrolloff = 8

-- Indentation
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.breakindent = true

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = false

-- Splits
vim.o.splitbelow = true
vim.o.splitright = true

-- UI and messages
vim.o.mouse = ""
vim.o.showmode = false
vim.opt.termguicolors = true
vim.o.cmdheight = 1
vim.o.pumheight = 10
vim.o.conceallevel = 0
vim.o.showtabline = 2

-- Backspace and word keys
vim.o.backspace = "indent,eol,start"
vim.opt.iskeyword:append("-")

-- Clipboard
vim.o.clipboard = "unnamedplus"

-- Files and backup
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.undofile = true
vim.o.fileencoding = "utf-8"

-- Timeout and update
vim.o.updatetime = 1000
vim.o.timeoutlen = 300

-- Completion and formatting
vim.o.completeopt = "menuone,noselect"
vim.opt.shortmess:append("c")
vim.opt.formatoptions:remove({ "c", "r", "o" })
vim.opt.fillchars = { eob = " " }

-- Whitespace characters
vim.opt.list = true
vim.opt.listchars = {
	tab = "· ",
	trail = "·",
	extends = ">",
	precedes = "<",
}

-- Folding
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
vim.wo.foldlevel = 99

-- Custom tab line
_G.MyTabLabel = function(n)
	local buf = vim.fn.bufname(vim.fn.tabpagebuflist(n)[vim.fn.tabpagewinnr(n)])
	return buf ~= "" and "../" .. vim.fn.fnamemodify(buf, ":t") or "[No Name]"
end

_G.MyTabLine = function()
	local s, cur, total = "", vim.fn.tabpagenr(), vim.fn.tabpagenr("$")
	for i = 1, total do
		s = s .. (i == cur and "%#TabLineSel#" or "%#TabLine#")
		s = s .. ("%%%dT %%{v:lua.MyTabLabel(%d)} "):format(i, i)
	end
	return s .. "%#TabLineFill#%T" .. (total > 1 and "%=%#TabLine#%999Xclose" or "")
end

vim.o.tabline = "%!v:lua.MyTabLine()"

-- Highlight groups
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		local set_hl = vim.api.nvim_set_hl
		set_hl(0, "TabLine", { bg = "none" })
		set_hl(0, "TabLineSel", { bg = "none", bold = true })
		set_hl(0, "TabLineFill", { bg = "none" })
		set_hl(0, "NormalFloat", { bg = "none" })
		set_hl(0, "FloatBorder", { bg = "none", fg = "none" })
		set_hl(0, "OilNormal", { bg = "none" })
		set_hl(0, "OilFloat", { bg = "none" })
	end,
})
