local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting -- to setup formatters
-- local diagnostics = null_ls.builtins.diagnostics -- to setup linters

-- Formatters & linters for mason to install
require("mason-null-ls").setup({
	ensure_installed = {
		"prettier", -- ts/js formatter
		"stylua", -- lua formatter
		"eslint_d", -- ts/js linter
		"shfmt", -- Shell formatter
	},
	automatic_installation = true,
})

local sources = {
	formatting.prettier.with({ filetypes = { "html", "json", "yaml", "markdown", "graphql" } }),
	formatting.stylua,
	formatting.shfmt.with({ args = { "-i", "4" } }),
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
	sources = sources,
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
})
