return {
  -- ,
  { -- To be enabled when latest stable neovim supports it
    'Bekaboo/dropbar.nvim',
    config = function()
      require('dropbar').setup({
        menu = {
          preview = false,
        },
      })
    end,
  },
}
