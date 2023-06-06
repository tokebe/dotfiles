return {
  'VonHeikemen/lsp-zero.nvim', -- Automatic LSP setup
  branch = 'v2.x',
  dependencies = {
    { 'neovim/nvim-lspconfig' }, -- Language server support
    {
      'williamboman/mason.nvim', -- Automatic LSP/DAP/linter/formatter management
      build = function()
        pcall(vim.cmd, 'MasonUpdate')
      end,
    },
    { 'williamboman/mason-lspconfig.nvim' }, -- integration
    { 'folke/neodev.nvim' },
    -- Autocompletion
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    -- { 'hrsh7th/cmp-nvim-lsp-signature-help' },
    { 'L3MON4D3/LuaSnip' },
    { 'hrsh7th/cmp-buffer' },
    { 'tzachar/cmp-fuzzy-path', dependencies = { 'tzachar/fuzzy.nvim' } },
    { 'hrsh7th/cmp-cmdline' },
    { 'dmitmel/cmp-cmdline-history' },
    { 'tamago324/cmp-zsh' },
    { 'onsails/lspkind.nvim' }, -- icons
    -- Formatting
    { 'jose-elias-alvarez/null-ls.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
    {
      'jay-babu/mason-null-ls.nvim',
      dependencies = {
        'williamboman/mason.nvim',
        'jose-elias-alvarez/null-ls.nvim',
      },
    },
    { 'aznhe21/actions-preview.nvim' },
    -- DAP
    { 'rcarriga/nvim-dap-ui', dependencies = { 'mfussenegger/nvim-dap' } },
    { 'jay-babu/mason-nvim-dap.nvim' },
    { 'Weissle/persistent-breakpoints.nvim' },
    { 'theHamsta/nvim-dap-virtual-text' },
    { 'rcarriga/cmp-dap' },
    { 'nvim-telescope/telescope-dap.nvim' },
    -- LSP rename preview
    { 'smjonas/inc-rename.nvim', dependencies = { 'stevearc/dressing.nvim' } },
    {
      'SmiteshP/nvim-navbuddy',
      dependencies = {
        'SmiteshP/nvim-navic',
        'MunifTanjim/nui.nvim',
      },
      opts = { lsp = { auto_attach = true } },
    },
    -- Inlay type hints
    { 'lvimuser/lsp-inlayhints.nvim' },
  },
  config = function() -- LSP loading status
    -- Set up neodev
    require('neodev').setup({
      library = { plugins = { 'nvim-dap-ui' }, types = true },
    })
    -- Set up Dressing
    require('config.dressing').config()
    -- Set up IncRename
    require('config.inc_rename').config()
    -- Set up Navbuddy
    require('config.nvim_navbuddy').config()
    -- Set up LSP
    local lsp = require('lsp-zero').preset('recommended')
    require('config.lsp_zero').config(lsp)

    -- Set up formatters
    local null_ls = require('null-ls')
    require('mason-null-ls').setup({
      ensure_installed = require('config.sources').formatter,
      automatic_setup = true,
      handlers = {
        yamllint = function()
          null_ls.register(null_ls.builtins.diagnostics.yamllint.with({
            extra_args = {
              '-d',
              'relaxed',
            },
          }))
        end,
        -- Supplying empty functions makes null_ls handle it instead
        yamlfix = function() end,
        prettier = function() end,
      },
    })
    -- Specify yamlfix before prettier so it loads first
    -- (This applies yamlfix formatting and then prettier to yaml files)
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.yamlfix,
        null_ls.builtins.formatting.prettier,
      },
    })

    -- Set up completion etc
    require('config.cmp').config(lsp)

    -- Set up DAPs
    -- require('config.dap').config()
  end,
}
