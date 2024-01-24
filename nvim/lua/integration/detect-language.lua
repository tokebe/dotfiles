return {
  'spywhere/detect-language.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    local util = require('util')
    require('detect-language').setup({
      events = { 'FileReadPost' },
    })
    util.keymap('n', '<Leader>dl', '<CMD>DetectLanguage<CR>', { desc = 'Detect Langauge' })
  end,
}
