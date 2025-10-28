return {
  {
    'tadmccorkle/markdown.nvim',
    ft = 'markdown',
    opts = {},
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    events = {
      'FileType',
    },
    opts = {
      file_types = {
        'markdown',
        'quarto',
        'rmd',
      },
      render_modes = { 'n', 'c', 'i' },
      heading = {
        width = 'block',
        min_width = 88,
        below = '▔',
        above = '▁',
        icons = {
          '█ ',
          '██ ',
          '███ ',
          '████ ',
          '█████ ',
          '██████ ',
        },
        border = true,
      },
      code = {
        position = 'right',
        language_pad = 1,
        width = 'block',
        min_width = 88,
        border = 'thick',
      },
    },
  },
  -- {
  --   'OXY2DEV/markview.nvim',
  --   lazy = false,
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter',
  --     'nvim-tree/nvim-web-devicons',
  --   },
  --   config = function()
  --     require('markview').setup({
  --       preview = {
  --         modes = { 'i', 'n', 'no', 'c' },
  --         hybrid_modes = { 'i' },
  --         linewise_hybrid_mode = true,
  --       },
  --     })
  --   end,
  -- },
}
