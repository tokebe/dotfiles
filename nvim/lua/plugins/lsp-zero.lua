return {
	"VonHeikemen/lsp-zero.nvim", -- Automatic LSP setup
	branch = "v2.x",
	dependencies = {
		{ "neovim/nvim-lspconfig" }, -- Language server support
		{
			"williamboman/mason.nvim", -- Automatic LSP/DAP/linter/formatter management
			build = function()
				pcall(vim.cmd, "MasonUpdate")
			end,
		},
		{ "williamboman/mason-lspconfig.nvim" }, -- integration
		{ "folke/neodev.nvim" },
		-- Autocompletion
		{ "hrsh7th/nvim-cmp" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-nvim-lsp-signature-help" },
		{ "L3MON4D3/LuaSnip" },
		{ "hrsh7th/cmp-buffer" },
		{ "tzachar/cmp-fuzzy-path", dependencies = { "tzachar/fuzzy.nvim" } },
		{ "hrsh7th/cmp-cmdline" },
		{ "dmitmel/cmp-cmdline-history" },
		{ "tamago324/cmp-zsh" },
		{ "onsails/lspkind.nvim" }, -- icons
		-- Formatting
		{ "jose-elias-alvarez/null-ls.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
		{
			"jay-babu/mason-null-ls.nvim",
			dependencies = {
				"williamboman/mason.nvim",
				"jose-elias-alvarez/null-ls.nvim",
			},
		},
		-- DAP
		{ "mfussenegger/nvim-dap" },
		{ "jay-babu/mason-nvim-dap.nvim" },
		-- Indicator
		{ "j-hui/fidget.nvim" },
		-- LSP rename preview
		{ "smjonas/inc-rename.nvim", dependencies = { "stevearc/dressing.nvim" } },
		{
			"SmiteshP/nvim-navbuddy",
			dependencies = {
				"SmiteshP/nvim-navic",
				"MunifTanjim/nui.nvim",
			},
			opts = { lsp = { auto_attach = true } },
		},
	},
	config = function()
		-- Set up neodev
		require("neodev").setup({})
		-- Set up Dressing
		require("config.dressing").config()
		-- Set up IncRename
		require("config.inc_rename").config()
		-- Set up Navbuddy
		require("config.nvim_navbuddy").config()
		-- Set up LSP
		local lsp = require("lsp-zero").preset("recommended")
		require("config.lsp_zero").config(lsp)
		require("fidget").setup() -- LSP loading status

		-- Set up formatters
		require("mason-null-ls").setup({
			ensure_installed = require("config.sources").formatter,
			automatic_setup = true,
			handlers = {},
		})
		require("null-ls").setup({
			sources = {},
		})

		-- Set up DAPs
		require("mason-nvim-dap").setup({
			automatic_setup = true,
			ensure_installed = require("config.sources").dap,
		})

		-- Set up completion etc
		require("config.cmp").config(lsp)
	end,
}
