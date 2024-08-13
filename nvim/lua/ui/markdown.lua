return {
  -- {
  --   'MeanderingProgrammer/markdown.nvim',
  --   name = 'render-markdown',
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter',
  --   },
  --   config = function()
  --     require('render-markdown').setup()
  --   end,
  -- },
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons'
    }
  }
}
