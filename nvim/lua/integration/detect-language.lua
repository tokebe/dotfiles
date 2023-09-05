return {
  'spywhere/detect-language.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter'
  },
  config = function ()
    require('detect-language').setup()
  end
}
