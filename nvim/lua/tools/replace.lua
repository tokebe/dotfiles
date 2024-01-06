return {
  'otavioschwanck/cool-substitute.nvim',
  config = function()
    require('cool-substitute').setup({
      setup_keybindings = true,
      -- mappings = {
      --   start = " rm"
      -- }
    })
  end,
}
