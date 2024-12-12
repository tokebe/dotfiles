return {
  {
    '2kabhishek/nerdy.nvim',
    dependencies = {
      'stevearc/dressing.nvim',
    },
    cmd = 'Nerdy',
    keys = {
      { '<Leader>fn', '<CMD>Nerdy<CR>', mode = 'n', { desc = 'Find nerdfont symbols' } },
    },
  },
}
