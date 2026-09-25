return {
  { -- Neovide-like cursor smear using block symbols
    'sphamba/smear-cursor.nvim',
    -- version = '0',
    lazy = false,
    opts = {
      -- cursor_color = "#ffffff",
      cursor_color = '#eb6f92',
      legacy_computing_symbols_support = false,
      hide_target_hack = true,
      smear_bettween_buffers = false,
      trailing_stiffness = 0.25,
    },
  },
  -- { -- Currently has problems with movement cancelling
  --   'declancm/cinnamon.nvim',
  --   version = '*',
  --   opts = {
  --     keymaps = {
  --       basic = true,
  --       extra = true,
  --     },
  --     options = {
  --       mode = 'window',
  --       max_delta = {
  --         time = 200,
  --       },
  --     },
  --   },
  -- },
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
