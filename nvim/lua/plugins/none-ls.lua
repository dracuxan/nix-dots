local vim = vim
local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting -- to setup formatters

local sources = {
	formatting.prettierd,
	formatting.shfmt.with({ args = { "-i", "4" } }),
	formatting.terraform_fmt,
	formatting.gofumpt,
	formatting.clang_format,
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
					vim.lsp.buf.format({ async = false })
				end,
			})
		end
	end,
})
