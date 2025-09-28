local vim = vim
local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting -- to setup formatters

-- Formatters & linters for mason to install
require("mason-null-ls").setup({
	ensure_installed = {
		"stylua", -- lua formatter
		"shfmt", -- Shell formatter
		"checkmake", -- linter for Makefiles
		"ruff", -- Python linter and formatter
		-- "golines",
		"gofumpt",
		"elm-format",
		"elm-language-server elmls",
		"clangd",
		"nil",
		"clang-format",
	},
	automatic_installation = true,
})

local sources = {
	formatting.prettier.with({ filetypes = { "html", "json", "yaml", "markdown", "graphql", "typescriptreact" } }),
	formatting.stylua,
	formatting.shfmt.with({ args = { "-i", "4" } }),
	formatting.terraform_fmt,
	formatting.gofumpt,
	formatting.clang_format,
	-- formatting.goimports_reviser,
	-- formatting.golines,
	-- require("none-ls.formatting.ruff").with({ extra_args = { "--extend-select", "I" } }),
	-- require("none-ls.formatting.ruff_format"),
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
