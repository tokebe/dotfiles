return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    require('mini.cursorword').setup()
    require('mini.move').setup()
    require('mini.comment').setup()
    -- require('mini.pairs').setup({
    --   mappings = {
    --     [' '] = { action = 'open', pair = '  ', neigh_pattern = '[{(%[][%])}]' }, -- in-bracket spacing
    --     ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\][%s%{%(%[%]%)%}]' },
    --     ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\][%s%{%(%[%]%)%}]' },
    --     ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\][%s%{%(%[%]%)%}]' },
    --     [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\][%s%{%(%[%]%)%}]' },
    --     [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\][%s%{%(%[%]%)%}]' },
    --     ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\][%s%{%(%[%]%)%}]' },
    --     ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
    --     ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
    --     ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
    --   }
    -- })
    require('mini.basics').setup({
      options = {
        basic = false,
        extra_ui = false,
        win_borders = 'double',
      },
      mappings = {
        basic = true,
        option_toggle_prefix = [[<Leader>o]],
        windows = true,
        move_with_alt = true,
      },
      autocommands = {
        basic = true,
        relnum_in_visual_mode = true,
      },
    })
    require('mini.animate').setup({
      cursor = {
        enable = false,
      },
      scroll = {
        enable = false,
      },
      resize = {
        enable = true,
      },
      open = {
        enable = true,
      },
      close = {
        enable = true,
      },
    })
  end,
}
