return {
  -- File minimap
  'gorbit99/codewindow.nvim',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter' }, -- syntax highlight
    { 'neovim/nvim-lspconfig' }, -- error highlight
  },
  config = function()
    local codewindow = require('codewindow')
    codewindow.setup({
      auto_enable = true,
      minimap_width = 10,
      width_multiplier = 4,
      window_border = 'none',
      exclude_filetypes = require('config.filetype_excludes'),
      events = { 'TextChanged', 'InsertLeave', 'DiagnosticChanged' }
    })
    codewindow.apply_default_keybinds()
  end,
}
