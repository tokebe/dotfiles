return {
  { -- Doesn't really work in this setup yet. Come back to it.
    'smjonas/live-command.nvim',
    config = function()
      require('live-command').setup({
        commands = {
          Norm = { cmd = 'norm', hl_range = { kind = 'visible' } },
        },
      })
    end,
  },
}
