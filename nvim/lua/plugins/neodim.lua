return {
  'zbirenbaum/neodim',
  event = "LspAttach",
  branch = 'v2',
  config = function ()
    require('neodim').setup({
      refresh_delay = 100,
      hide = { underline = false, virtual_text = false, signs = false }
    })
  end
}
