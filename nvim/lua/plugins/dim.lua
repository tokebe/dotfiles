return {
  'narutoxy/dim.lua',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'neovim/nvim-lspconfig',
  },
  config = function()
    require('dim').setup({
      disable_lsp_decorations = true
    })
  end
}
