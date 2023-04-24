local default_theme = 'sonokai'
vim.o.background = 'dark'
return {
  'rktjmp/lush.nvim',
  dependencies = {
    'olimorris/onedarkpro.nvim',
    'folke/tokyonight.nvim',
    'mcchrish/zenbones.nvim',
    'rose-pine/neovim',
    'sainnhe/sonokai',
    'ntk148v/habamax.nvim',
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

    -- require('barbecue').setup({
    --   theme = 'onedark',
    -- })
    require('lualine').setup({
      options = {
        theme = 'auto',
      },
    })
    vim.cmd('colorscheme ' .. default_theme)
  end,
}
