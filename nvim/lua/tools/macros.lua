local util = require('util')
return {
  {
    'ecthelionvi/NeoComposer.nvim',
    dependencies = {
      'kkharji/sqlite.lua',
    },
    config = function()
      -- TODO bind this to something more useful
      -- Handled by 'm' now
      vim.keymap.set('n', 'q', '<nop>')
      require('NeoComposer').setup({
        keymaps = {
          play_macro = 'M',
          yank_macro = 'ym',
          stop_macro = 'cm',
          toggle_record = 'm',
          toggle_macro_menu = '<Leader>mm',
          cycle_next = '<Leader>mj',
          cycle_prev = '<Leader>mk',
        },
      })
      util.keymap('n', '<Leader>md', '<CMD>ToggleDelay<CR>', { desc = 'Toggle macro delay' })
    end,
  },
}
