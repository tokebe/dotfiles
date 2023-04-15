return {
  config = function()
    require('nvim-navbuddy').setup({
      border = 'none',
      size = '80%',
      lsp = {
        auto_attach = true,
      }
    })
  end
}
