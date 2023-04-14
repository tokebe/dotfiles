return {
  'zbirenbaum/neodim',
  event = "LspAttach",
  config = function()
    require('neodim').setup({
      refresh_delay = 100,
      hide = { underline = true, virtual_text = true, signs = true }
    })
  end
}
