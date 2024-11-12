return {
  -- {
  --   'lewis6991/satellite.nvim',
  --   dependencies = { 'nvim-treesitter/nvim-treesitter', 'lewis6991/gitsigns.nvim' },
  --   config = function()
  --     require('satellite').setup({
  --       current_only = true,
  --       excluded_filetypes = require('config.filetype_excludes'),
  --     })
  --   end,
  -- },
  {
    'petertriho/nvim-scrollbar',
    dependencies = {
      'kevinhwang91/nvim-hlslens',
      'lewis6991/gitsigns.nvim',
    },
    config = function()
      require('scrollbar').setup({
        show_in_active_only = true,
        excluded_filetypes = require('config.filetype_excludes'),
        hide_if_all_visible = true,
        handlers = {
          cursor = true,
          diagnostic = true,
          gitsigns = false, -- Requires gitsigns
          handle = true,
          search = true,    -- Requires hlslens
        },
      })
      require('scrollbar.handlers.diagnostic').setup()
      require('scrollbar.handlers.gitsigns').setup()
      require('scrollbar.handlers.search').setup()
    end,
  },
  -- Not very friendly with wrap on
  -- {
  --   'Isrothy/neominimap.nvim',
  --   lazy = false,
  --   dependencies = { 'nvim-treesitter/nvim-treesitter', 'lewis6991/gitsigns.nvim' },
  --   keys = {
  --     {
  --       '<Leader>tm',
  --       '<CMD>Neominimap toggle<CR>',
  --       desc = 'Toggle minimap',
  --     },
  --     {
  --       'M',
  --       '<CMD>Neominimap toggleFocus<CR>',
  --       desc = 'Focus minimap (fast scroll)',
  --     },
  --   },
  --   config = function()
  --     vim.opt.sidescrolloff = 10
  --     vim.g.neominimap = {
  --       auto_enable = true,
  --       exclue_filestypes = require('config.filetype_excludes'),
  --       minimap_width = 10,
  --       click = {
  --         enabled = true,
  --         auto_switch_focus = false,
  --       },
  --       search = {
  --         enabled = true,
  --       },
  --       window_border = 'none',
  --     }
  --   end,
  -- },
}
