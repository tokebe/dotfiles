local util = require('util')
return {
  {
    'anuvyklack/windows.nvim',
    dependencies = {
      'anuvyklack/middleclass',
      -- 'anuvyklack/animation.nvim',
    },
    config = function()
      vim.o.winwidth = 15
      vim.o.winminwidth = 15
      vim.o.equalalways = false
      require('windows').setup({
        autowidth = {
          winwidth = 1.5,
        },
        animation = {
          duration = 150,
        },
      })

      util.keymap('n', '<Leader>ww', ':WindowsMaximize<CR>', {
        desc = 'Maximize current window',
      })
      util.keymap('n', '<Leader>we', ':WindowsEqualize<CR>', {
        desc = 'Equalize windows',
      })
      util.keymap('n', '<Leader>wW', ':WindowsToggleAutowidth<CR>', {
        desc = 'Toggle window autowidth',
      })
      util.keymap('n', '<Leader>wh', ':WindowsMaximizeHorizontally<CR>', {
        desc = 'Maximize window horizontally',
      })
      util.keymap('n', '<Leader>wv', ':WindowsMaximizeVertically<CR>', {
        desc = 'Maximize window vertically',
      })
    end,
  },
}
