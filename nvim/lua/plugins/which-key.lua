-- Which-key shows you pending keycodes, essentially a control-hints tray.
return {
  'folke/which-key.nvim',
  config = function()
    local which_key = require('which-key')
    which_key.setup({
      window = {
        winblend = 15
      }
    })
    -- Set up a seciton that doesn't really belong to anything
    which_key.register({
      ['<leader>g'] = {
        name = 'Global...'
      }
    })
  end
}
