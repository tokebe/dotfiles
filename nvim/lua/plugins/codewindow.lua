return {
  'gorbit99/codewindow.nvim',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter' }, -- syntax highlight
    { 'neovim/nvim-lspconfig' } -- error highlight
  },
  config = function()
    local codewindow = require('codewindow')
    codewindow.setup({
      auto_enable = true,
      minimap_width = 10,
      width_multiplier = 4,
      window_border = "none",
    })
    codewindow.apply_default_keybinds()
  end
}
