return {
  -- {
  --   'lewis6991/satellite.nvim',
  --   config = function()
  --     require('satellite').setup({})
  --   end,
  -- },
  {
    'dstein64/nvim-scrollview',
    config = function()
      require('scrollview').setup({
        excluded_filetypes = { 'nerdtree' },
        current_only = true,
        winblend = 50,
      })
    end,
  },
}
