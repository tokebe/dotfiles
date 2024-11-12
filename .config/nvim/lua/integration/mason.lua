local util = require('util')
return {
  {
    'williamboman/mason.nvim', -- Automatic LSP/DAP/linter/formatter management
    build = function()
      pcall(vim.cmd, 'MasonUpdate')
    end,
    config = function()
      require('mason').setup()

      vim.keymap.set('n', '<Leader>om', ':Mason<CR>', {
        desc = 'Manage LSPs with Mason',
      })
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig' },
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = require('config.sources').lsp,
        automatic_installation = true,
      })
    end,
  },
}
