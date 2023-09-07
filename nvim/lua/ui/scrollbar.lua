return {
  -- {
  --   'lewis6991/satellite.nvim',
  --   config = function()
  --     require('satellite').setup({})
  --   end,
  -- },
  -- {
  --   'dstein64/nvim-scrollview',
  --   config = function()
  --     require('scrollview').setup({
  --       excluded_filetypes = { 'nerdtree' },
  --       current_only = true,
  --       winblend = 50,
  --     })
  --   end,
  -- },
  {
    'petertriho/nvim-scrollbar',
    config = function()
      require('scrollbar').setup({
        show_in_active_only = true,
        excluded_filetypes = require('config.filetype_excludes'),
      })
    end,
  },
}
