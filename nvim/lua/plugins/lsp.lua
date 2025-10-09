local vim = vim
local augroup = augroup
local bufnr = bufnr
-- local function organize_imports()
-- 	local params = {
-- 		command = "_typescript.organizeImports",
-- 		arguments = { vim.api.nvim_buf_get_name(0) },
-- 	}
-- 	vim.lsp.buf.execute_command(params)
-- 	-- Client:exec_cmd(params)
-- end

return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Useful status updates for LSP.
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{ "j-hui/fidget.nvim", opts = {} },

		-- Allows extra capabilities provided by nvim-cmp
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local lspconfig = require("lspconfig")
		local util = lspconfig.util
		-- Brief aside: **What is LSP?**
		--
		-- LSP is an initialism you've probably heard, but might not understand what it is.
		--
		-- LSP stands for Language Server Protocol. It's a protocol that helps editors
		-- and language tooling communicate in a standardized fashion.
		--
		-- In general, you have a "server" which is some tool built to understand a particular
		-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
		-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
		-- processes that communicate with some "client" - in this case, Neovim!
		--
		-- LSP provides Neovim with features like:
		--  - Go to definition
		--  - Find references
		--  - Autocompletion
		--  - Symbol Search
		--  - and more!
		--
		-- Thus, Language Servers are external tools that must be installed separately from
		-- Neovim. This is where `mason` and related plugins come into play.
		--
		-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
		-- and elegantly composed help section, `:help lsp-vs-treesitter`

		--  This function gets run when an LSP attaches to a particular buffer.
		--    That is to say, every time a new file is opened that is associated with
		--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
		--    function will be executed to configure the current buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				-- NOTE: Remember that Lua is a real programming language, and as such it is possible
				-- to define small helper and utility functions so you don't have to repeat yourself.
				--
				-- In this case, we create a function that lets us more easily define mappings specific
				-- for LSP related items. It sets the mode, buffer and description for us each time.
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

				-- The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				--    See `:help CursorHold` for information about when this is executed
				--
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
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

				-- The following code creates a keymap to toggle inlay hints in your
				-- code, if the language server you are using supports them
				--
				-- This may be unwanted, since they displace some of your code
				-- if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
				-- 	map("<leader>th", function()
				-- 		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
				-- 	end, "[T]oggle Inlay [H]ints")
				-- end
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

		-- LSP servers and clients are able to communicate to each other what features they support.
		--  By default, Neovim doesn't support everything that is in the LSP specification.
		--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
		--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		local servers = {

			nil_ls = {
				capabilities = capabilities,
				filetypes = { "nix" },
			},

			clangd = {
				capabilities = capabilities,
				filetypes = { "c", "cpp", "objc", "objcpp", "h" },
			},

			bashls = {
				capabilities = capabilities,
			},

			gopls = {
				capabilities = capabilities,
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl", "templ" },
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
						gofumpt = true,
					},
				},
			},
			pyright = {
				capabilities = capabilities,
			},

			rust_analyzer = {
				capabilities = capabilities,
				settings = {
					["rust-analyzer"] = {
						cargo = {
							loadOutDirsFromCheck = true,
						},
						procMacro = {
							enable = true,
						},
					},
				},
			},

			html = { filetypes = { "html", "twig", "hbs", "tsx" } },
			cssls = {},

			zls = {
				capabilities = capabilities,
			},

			elmls = {
				capabilities = capabilities,
				cmd = { "elm-language-server" },
				filetypes = { "elm" },
				init_options = {
					elmAnalyseTrigger = "change", -- Or "file_open", "save"
					elmFormatPath = "elm-format", -- Path to elm-format executable
					elmPath = "elm", -- Path to the elm executable
					elmTestPath = "elm-test", -- Path to the elm-test executable
				},
				root_dir = util.root_pattern("elm.json"),
			},

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
		}

		ts_ls = {
			capabilities = capabilities,
			settings = {
				typescript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
					},
				},
			},
		}
		-- Ensure the servers and tools above are installed
		--  To check the current status of installed tools and/or manually install
		--  other tools, you can run
		--    :Mason
		--
		--  You can press `g?` for help in this menu.
		require("mason").setup()

		-- You can add other tools here that you want Mason to install
		-- for you, so that they are available from within Neovim.
		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua", -- Used to format Lua code
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					-- This handles overriding only values explicitly passed
					-- by the server configuration above. Useful when disabling
					-- certain features of an LSP (for example, turning off formatting for tsserver)
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}
