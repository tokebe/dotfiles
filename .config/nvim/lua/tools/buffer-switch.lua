return {
  {
    'toppair/reach.nvim',
    config = function()
      local reach = require('reach')
      reach.setup()
      vim.keymap.set('n', '<Tab>', function()
        vim.cmd('b#')
        reach.buffers({
          handle = 'dynamic',
          modified_icon = ' 󰏫 ',
          show_current = true,
          grayout_current = false,
          previous = {
            enabled = true,
            depth = 2,
            chars = { '󰋚' },
          },
          actions = {
            split = ';',
            vertsplit = "'",
            delete = '<Backspace>',
          },
        })
      end, { desc = 'Switch buffers' })
      -- vim.keymap.set('n', '<Tab>', ':b#<CR>')
    end,
  },
}
