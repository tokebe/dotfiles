return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    require('mini.cursorword').setup()
    require('mini.move').setup()
    require('mini.comment').setup()
    require('mini.pairs').setup({
      mappings = {
        [' '] = { action = 'open', pair = '  ', neigh_pattern = '[{(%[][%])}]' }, -- in-bracket spacing
      }
    })
    require('mini.basics').setup({
      options = {
        basic = false,
        extra_ui = true,
        win_borders = "double",
      },
      mappings = {
        basic = true,
        option_toggle_prefix = [[<Leader>t]],
        windows = true,
        move_with_alt = true,
      },
      autocommands = {
        basic = true,
        relnum_in_visual_mode = true,
      }
    })
  end
}
