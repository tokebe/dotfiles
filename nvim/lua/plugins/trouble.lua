return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function ()
    require('trouble').setup({
      mode = 'document_diagnostics'
    })
  end
}
