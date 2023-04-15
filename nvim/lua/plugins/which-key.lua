-- Which-key shows you pending keycodes, essentially a control-hints tray.
return {
  'folke/which-key.nvim',
  config = function()
    local which_key = require('which-key')
    which_key.setup({
      icons = {
        group = "»"
      }
    })
  end
}
