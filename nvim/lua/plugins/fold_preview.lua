return {
  'anuvyklack/fold-preview.nvim',
  dependencies = {
    { 'anuvyklack/keymap-amend.nvim' },
  },
  config = function()
    require('fold-preview').setup({
      auto = 400,
      border = 'none',
    })
  end,
}
