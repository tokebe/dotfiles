local util = require('util')
return {
  {
    'MagicDuck/grug-far.nvim',
    config = function()
      require('grug-far').setup({
        keymaps = {
          close = { n = 'q' },
        },
      })
      util.keymap('n', '<Leader>ff', function()
        require('grug-far').grug_far({
          prefills = {
            filesFilter = string.format(
              '!{%s}',
              table.concat(vim.split(require('filter').formatFilter(), '\n', { plain = true }), ',')
            ),
          },
        })
      end, { desc = 'Search within files' })

      util.keymap('n', '<Leader>fF', function()
        require('grug-far').grug_far({
          prefills = {
            filesFilter = vim.fn.expand('%'),
          },
        })
      end, { desc = 'Search within current file' })
    end,
  },
}
