local util = require('util')
return {
  {
    'MagicDuck/grug-far.nvim',
    config = function()
      require('grug-far').setup({
        startInInsertMode = false,
        keymaps = {
          close = { n = 'q' },
        },
        prefills = {
          flags = '--ignore-case --no-ignore'
        }
      })
      vim.keymap.set('n', '<Leader>ff', function()
        require('grug-far').grug_far({
          prefills = {
            filesFilter = require('filter').getFilter(),
          },
        })
      end, { desc = 'Search within files' })

      vim.keymap.set('n', '<Leader>fF', function()
        require('grug-far').grug_far({
          prefills = {
            filesFilter = vim.fn.expand('%'),
          },
        })
      end, { desc = 'Search within current file' })
    end,
  },
}
