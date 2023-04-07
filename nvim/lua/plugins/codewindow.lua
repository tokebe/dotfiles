return {
  'gorbit99/codewindow.nvim',
  event = 'BufEnter',
  config = function()
    local codewindow = require('codewindow')
    codewindow.setup({
      auto_enable = true,
      minimap_width = 10,
      window_border = "none",
    })
    codewindow.apply_default_keybinds()
  end
}
