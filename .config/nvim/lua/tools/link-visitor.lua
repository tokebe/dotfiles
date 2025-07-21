local util = require('util')
return {
  { -- Open links
    'xiyaowong/link-visitor.nvim',
    config = function()
      vim.keymap.set({ 'n' }, '<Leader>uo', require('link-visitor').link_nearest, { desc = 'Open nearest URL' })
    end,
  },
}
