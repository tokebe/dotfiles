local util = require('util')
return {
  'cshuaimin/ssr.nvim',
  config = function()
    require('ssr').setup({
      border = 'none',
    })
    util.keymap({ 'n', 'v' }, '<Leader>gR', function()
      require('ssr').open()
    end, { desc = 'Structural replace' })
  end,
}
