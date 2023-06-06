return {
  'nvim-pack/nvim-spectre',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('spectre').setup({
      open_cmd = 'botright vnew',
      -- TODO add binding in keymap.lua
      color_devicons = true,
      live_update = true,
      line_sep_start = '┌-----------------------------------------',
      result_padding = '┆  ',
      line_sep = '└-----------------------------------------',
      highlight = {
        search = 'DiffAdd',
        replace = 'DiffDelete',
        -- search = 'IncSearch',
        -- replace = 'IncSearch',
      },
    })
  end,
}
