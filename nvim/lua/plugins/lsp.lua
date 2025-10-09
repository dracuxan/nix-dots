local vim = vim
local augroup = augroup
local bufnr = bufnr

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		{ "j-hui/fidget.nvim", opts = {} },

		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local lspconfig = require("lspconfig")
		local util = lspconfig.util
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				local fzf = require("fzf-lua")
				-- Jump to the definition of the word under your cursor
				map("gd", fzf.lsp_definitions, "[G]oto [D]efinition")

				-- Find references for the word under your cursor
				map("gr", fzf.lsp_references, "[G]oto [R]eferences")

				-- Jump to the implementation of the word under your cursor
				map("gI", fzf.lsp_implementations, "[G]oto [I]mplementation")

				-- Jump to the type of the word under your cursor
				map("<leader>D", fzf.lsp_typedefs, "Type [D]efinition")

				-- Fuzzy find all the symbols in your current document
				map("<leader>ds", fzf.lsp_document_symbols, "[D]ocument [S]ymbols")

				-- Fuzzy find all the symbols in your current workspace
				map("<leader>ws", fzf.lsp_live_workspace_symbols, "[W]orkspace [S]ymbols")
				-- Rename the variable under your cursor.
				--  Most Language Servers support renaming across files, etc.
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

				-- Execute a code action, usually your cursor needs to be on top of an error
				-- or a suggestion from your LSP for this to activate.
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({
						group = augroup,
						buffer = bufnr,
					})

					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ bufnr = bufnr })
						end,
					})

					vim.diagnostic.config({
						update_in_insert = true, -- Show errors while typing
						virtual_text = true, -- Show inline errors
						signs = true, -- Show signs in the gutter
						underline = true, -- Underline errors
					})
				end

				vim.api.nvim_create_autocmd("BufWritePre", {
					pattern = "*.go",
					callback = function()
						local params = vim.lsp.util.make_range_params(0, "utf-16")
						params.context = { only = { "source.organizeImports" } }
						local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
						for cid, res in pairs(result or {}) do
							for _, r in pairs(res.result or {}) do
								if r.edit then
									local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
									vim.lsp.util.apply_workspace_edit(r.edit, enc)
								end
							end
						end
						vim.lsp.buf.format({ async = false })
					end,
				})
			end,
		})

		local servers = {
			lua_ls = {
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						runtime = { version = "LuaJIT" },
						diagnostics = { disable = { "missing-fields" }, globals = { "vim" } },
						format = {
							enable = false,
						},
					},
				},
			},
			html = {},
			cssls = {},
			gopls = {},
			rust_analyzer = {},
			nil_ls = {},
			clangd = {},
			bashls = {},
			pyright = {},
			zls = {},
			ts_ls = {},
			eslint = {},
		}

		require("mason").setup()

		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua",
			"shfmt",
			"checkmake",
			"ruff",
			"gofumpt",
			"clang-format",
			"prettierd",
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}
