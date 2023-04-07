-- Colorscheme(s). TODO find a way to manage/switch colorschemes
return {
  -- Theme inspired by Atom
  'folke/tokyonight.nvim',
  branch = 'main',
  priority = 1000,
  config = function()
    vim.cmd [[colorscheme tokyonight-storm]]
    require('barbecue').setup({
      theme = 'tokyonight-storm',
    })
    require('lualine').setup({
      options = {
        theme = 'tokyonight'
      }
    })
  end,
}
