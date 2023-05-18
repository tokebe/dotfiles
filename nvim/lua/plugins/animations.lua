return {
  {
    -- Animate cursor jumping larger distances
    'edluffy/specs.nvim',
    event = 'BufEnter',
    config = function()
      require('specs').setup({
        show_jumps = true,
        min_jump = 5,
        popup = {
          delay_ms = 0, -- delay before popup displays
          inc_ms = 10, -- time increments used for fade/resize effects
          blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
          width = 10,
          winhl = 'Search',
          fader = require('specs').pulse_fader,
          resizer = require('specs').shrink_resizer,
        },
        ignore_filetypes = {},
        ignore_buftypes = {
          nofile = true,
        },
      })
    end,
  },
  {
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
  {
    'declancm/cinnamon.nvim',
    config = function()
      require('cinnamon').setup({
        extra_keymaps = true,
        extended_keymaps = true,
      })
    end,
  },
  {
    'anuvyklack/windows.nvim',
    dependencies = {
      'anuvyklack/middleclass',
      'anuvyklack/animation.nvim',
    },
      config = function()
        vim.o.winwidth = 15
        vim.o.windminwidth = 15
        vim.o.equalalways = false
        require('windows').setup()
      end
  }
  -- currently too buggy to trust
  -- {
  --   'huy-hng/anyline.nvim',
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter',
  --   },
  --   config = true,
  --   event = 'VeryLazy',
  --   ft_ignore = require('config.filetype_excludes'),
  -- },
}
