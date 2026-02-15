local util = require('util')
local default_theme = 'sonokai'
return {
  {
    'rktjmp/lush.nvim',
    dependencies = {
      'olimorris/onedarkpro.nvim',
      'folke/tokyonight.nvim',
      'mcchrish/zenbones.nvim',
      'rose-pine/neovim',
      'sainnhe/sonokai',
      'ntk148v/habamax.nvim',
      'nyngwang/nvimgelion',
      'xero/evangelion.nvim',
      'wheat-thin-wiens/rei.nvim',
      'thedenisnikulin/vim-cyberpunk',
      'kungfusheep/mfd.nvim',
      -- Persistent colorscheme
      'raddari/last-color.nvim',
      -- Toggleable background transparency
      'xiyaowong/transparent.nvim',
    },
    priority = 1000,
    config = function()
      require('onedarkpro').setup({
        options = {
          cursorline = true,
          transparency = false,
          -- highlight_inactive_windows = true,
        },
      })
      -- local rose_pine_palette = require('rose-pine.palette')
      require('rose-pine').setup({
        highlight_groups = {
          WinSeparator = { fg = '#1f1d2e', bg = 'base' },
          CurSearch = { fg = 'base', bg = 'leaf', inherit = false },
          Search = { fg = 'text', bg = 'leaf', blend = 20, inherit = false },
          Visual = { bg = 'iris', blend = 30 },
        },
      })
      require('tokyonight').setup({
        style = 'storm',
      })

      vim.g.zenbones = {
        lightness = 'dim',
      }

      require('lualine').setup({
        options = {
          theme = 'auto',
        },
      })
      local colorscheme = require('last-color').recall() or default_theme
      vim.cmd('colorscheme ' .. colorscheme)
      require('transparent').setup({})

      vim.keymap.set('n', '<Leader>ott', ':TransparentToggle<CR>', {
        desc = 'Toggle transparent background',
      })
    end,
  },
}
