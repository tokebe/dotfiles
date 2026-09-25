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
    vim.keymap.set('n', '<Leader>sL', '<CMD>DetectLanguage<CR>', { desc = 'Detect Langauge' })
  end,
}
