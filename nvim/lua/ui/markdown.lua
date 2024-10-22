return {
  {
    'MeanderingProgrammer/markdown.nvim',
    name = 'render-markdown',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    events = {
      'FileType'
    },
    config = function()
      require('render-markdown').setup({
        file_types = {
          'markdown',
          'quarto',
          'rmd',
        },
        render_modes = { 'n', 'c' },
        heading = {
          width = 'block',
          min_width = 88,
          border = true,
        },
        code = {
          position = 'right',
          language_pad = 1,
          width = 'block',
          min_width = 88,
          border = 'thick',
        },
      })
    end,
  },
  -- {
  --   'OXY2DEV/markview.nvim',
  --   lazy = false,
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter',
  --     'nvim-tree/nvim-web-devicons'
  --   }
  -- }
}
