return {
  {
    'tomiis4/hypersonic.nvim',
    config = function()
      require('hypersonic').setup({
        border = 'none',
      })
    end,
    cmd = 'Hypersonic',
    keys = {
      {
        '<Leader>er',
        ':Hypersonic<CR>',
        mode = { 'n', 'v' },
        desc = 'Explain selected regex',
      },
    },
  },
}
