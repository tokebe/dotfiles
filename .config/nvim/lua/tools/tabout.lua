return {
  'abecodes/tabout.nvim',
  config = function()
    require('tabout').setup({
      ignore_beginning = false,
      act_as_tab = true,
    })
  end,
}
