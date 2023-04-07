-- Which-key shows you pending keycodes, essentially a control-hints tray.
return {
  'folke/which-key.nvim',
  config = function()
    require('which-key').setup({
      window = {
        winblend = 15
      }
    })
  end
}
