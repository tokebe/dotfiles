return {
  -- {
  --   -- Animate cursor jumping larger distances
  --   'edluffy/specs.nvim',
  --   event = 'BufEnter',
  --   config = function()
  --     require('specs').setup({
  --       show_jumps = true,
  --       min_jump = 5,
  --       popup = {
  --         delay_ms = 0, -- delay before popup displays
  --         inc_ms = 10, -- time increments used for fade/resize effects
  --         blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
  --         width = 10,
  --         winhl = 'Search',
  --         fader = require('specs').pulse_fader,
  --         resizer = require('specs').shrink_resizer,
  --       },
  --       ignore_filetypes = {},
  --       ignore_buftypes = {
  --         nofile = true,
  --       },
  --     })
  --   end,
  -- },
  { -- Smoothly move cursor
    'gen740/SmoothCursor.nvim',
    event = 'BufEnter',
    config = function()
      require('smoothcursor').setup({
        autostart = true,
        cursor = '',
        linehl = 'CursorLine',
      })
    end,
  },
  { -- misc animations
    'echasnovski/mini.animate',
    config = function()
      require('mini.animate').setup({
        cursor = {
          enable = false, -- handled by SmoothCursor.nvim
        },
        scroll = {
          enable = false, -- Meh
        },
        resize = {
          enable = false, -- handled in neovide
        },
        open = {
          enable = true,
        },
        close = {
          enable = true,
        },
      })
    end,
  },
}
