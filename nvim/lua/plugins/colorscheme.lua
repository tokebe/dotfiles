-- Colorscheme(s). TODO find a way to manage/switch colorschemes
return {
  'olimorris/onedarkpro.nvim',
  priority = 1000,
  config = function()
    vim.cmd('colorscheme onedark')
    require('barbecue').setup({
      theme = 'onedark',
    })
    require('lualine').setup({
      options = {
        theme = 'onedark'
      }
    })
  end,
}
