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
      require('rose-pine').setup()
      require('tokyonight').setup({
        style = 'storm',
      })

      vim.g.zenbones = {
        lightness = 'dim',
      }

      -- require('barbecue').setup({
      --   theme = 'onedark',
      -- })
      require('lualine').setup({
        options = {
          theme = 'auto',
        },
      })
      local colorscheme = require('last-color').recall() or default_theme
      vim.cmd('colorscheme ' .. colorscheme)
      require('transparent').setup({})

      vim.keymap.set('n', '<Leader>ot', ':TransparentToggle<CR>', {
        desc = 'Toggle transparent background',
      })

      vim.keymap.set('n', '<Leader>sd', function()
        if vim.o.background == 'dark' then
          vim.o.background = 'light'
        else
          vim.o.background = 'dark'
        end
      end, {
        desc = 'Set dark or light mode',
      })
    end,
  },
}
