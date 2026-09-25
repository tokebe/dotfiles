return {
  {
    'aikhe/wrapped.nvim',
    opts = {
      size = {
        height = 0.9,
      },
      caps = {
        plugins = 300,
        plugins_ever = 500,
        lines = 100000,
      },
    },
    keys = {
      {
        '<Leader>os',
        '<CMD>NvimWrapped<CR>',
        desc = 'View coding stats.',
      },
    },
  },
  {
    'nvzone/typr',
    dependencies = 'nvzone/volt',
    opts = {},
    cmd = { 'Typr', 'TyprStats' },
  },
}
