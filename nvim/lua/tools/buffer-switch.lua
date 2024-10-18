return {
  -- TODO: fork and make a PR for tab for most recent behavior
  {
    'toppair/reach.nvim',
    config = function()
      local reach = require('reach')
      reach.setup()
      vim.keymap.set('n', '<Tab>', function()
        reach.buffers({
          handle = 'dynamic',
          modified_icon = ' 󰏫 ',
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
