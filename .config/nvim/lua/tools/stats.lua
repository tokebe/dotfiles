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
    'gisketch/triforce.nvim',
    opts = {
      notifications = {
        enabled = false,
      },
      keymap = {
        show_profile = '<Leader>oS',
      },
    },
  },
}
