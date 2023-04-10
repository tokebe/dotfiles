return {
         -- File minimap
  'gorbit99/codewindow.nvim',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter' }, -- syntax highlight
    { 'neovim/nvim-lspconfig' }            -- error highlight
  },
  config = function()
    local codewindow = require('codewindow')
    codewindow.setup({
                       -- TODO don't appear in cmdline and such
      auto_enable = true,
      minimap_width = 10,
      width_multiplier = 4,
      window_border = "none",
    })
    -- Set up which-key hint
    require('which-key').register({
      ['<leader>m'] = {
        name = "Minimap..."
      }
    })
    codewindow.apply_default_keybinds()
  end
}
