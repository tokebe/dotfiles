local util = require('util')
return {
  { -- Open links
    'xiyaowong/link-visitor.nvim',
    config = function()
      util.keymap({ 'n' }, '<Leader>gu', require('link-visitor').link_nearest, { desc = 'Open nearest URL' })
    end,
  },
}
