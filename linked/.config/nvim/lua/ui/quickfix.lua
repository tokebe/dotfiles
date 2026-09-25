return {
  {
    'stevearc/quicker.nvim',
    ft = 'qf',
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {
      keys = {
        {
          'R',
          function()
            require('quicker').refresh()
          end,
        },
      },
    },
    keys = {
      {
        '<Leader>fq',
        function()
          require('quicker').toggle({ focus = true })
        end,
        desc = 'Toggle Quickfix list',
      },
      {
        '<Leader>fQ',
        function()
          require('quicker').toggle({ loclist = true, focus = true })
        end,
        desc = 'Toggle loclist',
      },
    },
  },
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    dependencies = {
      { 'junegunn/fzf', build = './install' },
    },
    opts = {
      auto_enable = true,
      auto_resize_height = true,
      preview = {
        win_vheight = 9,
        win_height = 9,
        border = 'single',
        wrap = true,
      },
      func_map = {
        fzffilter = '<Leader>f',
        filter = '<Leader>n',
        filterr = '<Leader>N',
      },
      filter = {
        fzf = {
          extra_opts = {
            '--bind',
            'ctrl-f:preview-half-page-down,ctrl-b:preview-half-page-up,ctrl-s:toggle-all',
            '--delimiter',
            '│',
          },
        },
      },
    },
  },
}
