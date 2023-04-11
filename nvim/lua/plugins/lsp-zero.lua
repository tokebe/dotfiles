local myLsps = {
  'lua_ls',
  'tsserver',
}

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
    { 'hrsh7th/cmp-nvim-lsp-signature-help' },
    { 'L3MON4D3/LuaSnip' },
    { 'hrsh7th/cmp-buffer' },
    { 'FelipeLema/cmp-async-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'dmitmel/cmp-cmdline-history' },
    { 'tamago324/cmp-zsh' },
    { 'onsails/lspkind.nvim' }, -- icons
    -- Formatting
    -- Indicator
    { 'j-hui/fidget.nvim' },
    -- LSP rename preview
    { 'smjonas/inc-rename.nvim',            dependencies = { 'stevearc/dressing.nvim' } },
    {
      'SmiteshP/nvim-navbuddy',
      dependencies = {
        'SmiteshP/nvim-navic',
        'MunifTanjim/nui.nvim'
      },
      opts = { lsp = { auto_attach = true } },
    },
  },
  config = function()
    -- Set up neodev
    require('neodev').setup({})
    -- Set up Dressing
    require('config.dressing').config()
    -- Set up IncRename
    require('config.inc_rename').config()
    -- Set up Navbuddy
    require('config.nvim_navbuddy').config()
    -- Set up LSP
    local lsp = require('lsp-zero').preset('recommended')
    require('config.lsp_zero').config(lsp)

    require('fidget').setup() -- LSP loading status
    -- Format keybind
    vim.keymap.set('n', '<leader>gf', function()
      vim.lsp.buf.format({ async = true })
    end, { desc = 'Format Buffer' })
    -- buffer
    vim.keymap.set('v', '<leader>gf', function()
      vim.lsp.buf.format({
        async = true,
        range = {
          ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
          ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
        }
      })
    end, { desc = 'Format Visual' })

    -- Set up completion etc
    require('config.cmp').config(lsp)
  end
}
