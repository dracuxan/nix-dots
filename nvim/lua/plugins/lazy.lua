-- Set up the Lazy plugin manager
local vim = vim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

local custom_plugins = {
	{
		"folke/noice.nvim",
		config = function()
			require("noice").setup({
				-- add any options here
				routes = {
					{
						filter = {
							event = "msg_show",
							any = {
								{ find = "%d+L, %d+B" },
								{ find = "; after #%d+" },
								{ find = "; before #%d+" },
								{ find = "%d fewer lines" },
								{ find = "%d more lines" },
							},
						},
						opts = { skip = true },
					},
				},
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					lsp_doc_border = true, -- add a border to hover docs and signature help
				},
			})
		end,
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			--   "rcarriga/nvim-notify",
		},
	},

	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("plugins.toggleterm")
		end,
		lazy = false,
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		lazy = false, -- neo-tree will lazily load itself
		---@module "neo-tree"
		---@type neotree.Config?
		opts = {
			-- fill any relevant options here
		},
		config = function()
			require("plugins.neo-tree")
		end,
	},

	{ "wakatime/vim-wakatime", lazy = false },

	-- colorschemes

	-- {
	-- 	"rebelot/kanagawa.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("plugins.kanagawa")
	-- 	end,
	-- },

	-- {
	-- 	"Mofiqul/vscode.nvim",
	-- 	version = false,
	-- 	lazy = false,
	-- 	priority = 1000, -- make sure to load this before all the other start plugins
	-- 	-- Optional; default configuration will be used if setup isn't called.
	-- 	config = function()
	-- 		require("plugins.vscode")
	-- 	end,
	-- },

	{
		"datsfilipe/vesper.nvim",
		version = false,
		lazy = false,
		priority = 1000, -- make sure to load this before all the other start plugins
		-- Optional; default configuration will be used if setup isn't called.
		config = function()
			require("plugins.vesper")
		end,
	},

	--

	{
		"rmagatti/auto-session",
		config = function()
			require("auto-session").setup({
				log_level = "error",

				auto_session_suppress_dirs = { "~/", "~/Downloads" },
			})
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		disabled_filetypes = { "alpha" },
		config = function()
			require("plugins.lualine")
		end,
	},

	{
		"folke/which-key.nvim",
		lazy = false,
		config = function()
			require("which-key").setup({
				plugins = {
					spelling = {
						enabled = true,
					},
				},
				win = {
					border = "single",
				},
				timeout = true,
				timeoutlen = 1000,
			})
		end,
	},

	{
		"akinsho/bufferline.nvim",
		lazy = false,
		dependencies = {
			"moll/vim-bbye",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("plugins.bufferline")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs", -- Sets main module to use for opts
		config = function()
			require("plugins.treesitter") -- Loads the Treesitter configuration
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("plugins.telescope") -- Loads the Telescope configuration
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
			},
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			require("plugins.cmp")
		end,
	},

	require("plugins.lsp"),

	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvimtools/none-ls-extras.nvim",
			"jayp0521/mason-null-ls.nvim", -- ensures dependencies are installed
		},
		config = function()
			require("plugins.none-ls")
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			signs_staged = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{
		"numToStr/Comment.nvim",
		opts = {},
		config = function()
			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "<C-_>", require("Comment.api").toggle.linewise.current, opts)
			vim.keymap.set("n", "<C-c>", require("Comment.api").toggle.linewise.current, opts)
			vim.keymap.set("n", "<C-/>", require("Comment.api").toggle.linewise.current, opts)
			vim.keymap.set(
				"v",
				"<C-_>",
				"<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
				opts
			)
			vim.keymap.set(
				"v",
				"<C-c>",
				"<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
				opts
			)
			vim.keymap.set(
				"v",
				"<C-/>",
				"<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
				opts
			)
		end,
	},
	{
		"goolord/alpha-nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},

		config = function()
			require("plugins.alpha")
		end,
	},

	require("plugins.misic"),

	{
		"mfussenegger/nvim-dap",
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		lazy = false,
		config = function(_, opts)
			require("nvim-dap-virtual-text").setup(opts)
		end,
	},
	{
		"olexsmir/gopher.nvim",
		ft = "go",
		config = function(_, opts)
			require("gopher").setup(opts)
		end,
		build = function()
			vim.cmd([[silent! GoInstallDeps]])
		end,
	},
}

require("lazy").setup(custom_plugins)
