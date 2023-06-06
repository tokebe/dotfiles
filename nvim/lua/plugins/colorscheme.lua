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
    'nyngwang/nvimgelion',
    -- Persistent colorscheme
    { 'propet/colorscheme-persist.nvim', dependencies = { 'nvim-telescope/telescope-dap.nvim' } },
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

    vim.o.background = 'light';
    vim.g.zenbones = {
      lightness = 'dim' 
    }

    -- require('barbecue').setup({
    --   theme = 'onedark',
    -- })
    require('lualine').setup({
      options = {
        theme = 'auto',
      },
    })
    local persist_colorscheme = require('colorscheme-persist')
    persist_colorscheme.setup({
      fallback = default_theme,
    })
    local colorscheme = persist_colorscheme.get_colorscheme()
    vim.cmd('colorscheme ' .. colorscheme)
    require('transparent').setup()
  end,
}
