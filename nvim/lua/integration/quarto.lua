return {
  {
    'quarto-dev/quarto-nvim',
    dependencies = {
      'jmbuhr/otter.nvim',
      'nvim-treesitter/nvim-treesitter',
      'benlubas/molten-nvim',
    },
    config = function()
      require('quarto').setup({ codeRunner = { enabled = true, default_method = 'molten' } })
    end,
  },
}
