local filter = require('filter')
return {
  {
    'MagicDuck/grug-far.nvim',
    config = function()
      local grug = require('grug-far')
      grug.setup({
        startInInsertMode = false,
        keymaps = {
          close = { n = 'q' },
        },
        prefills = {
          flags = '--ignore-case --no-ignore --hidden',
        },
        transient = true,
      })

      vim.keymap.set({ 'n', 'v' }, '<Leader>ff', function()
        grug.grug_far({
          prefills = {
            filesFilter = filter.getFilter(),
          },
        })
      end, { desc = 'Search within files' })

      vim.keymap.set({ 'n', 'v' }, '<Leader>fF', function()
        grug.grug_far({
          prefills = {
            filesFilter = vim.fn.expand('%'),
          },
        })
      end, { desc = 'Search within current file' })

      vim.keymap.set({ 'n', 'v' }, '<Leader>fa', function()
        grug.grug_far({
          engine = 'astgrep',
          prefills = {
            filesFilter = filter.getFilter(),
            flags = '',
          },
        })
      end, { desc = 'Search AST within files' })

      vim.keymap.set({ 'n', 'v' }, '<Leader>fA', function()
        grug.grug_far({
          engine = 'astgrep',
          prefills = {
            filesFilter = vim.fn.expand('%'),
            flags = '',
          },
        })
      end, { desc = 'Search AST within current file' })
    end,
  },
}
