return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local trouble = require('trouble')
    trouble.setup({
      focus = true,
    })
  end,
  event = 'LspAttach',
  keys = {
    {
      '<Leader>ta',
      ':TroubleToggle<CR>',
      desc = 'Toggle Trouble view',
    },
    {
      '<Leader>fd',
      ':Trouble diagnostics<CR>',
      desc = 'Find diagnostics',
    },
    {
      '<Leader>fq',
      ':Trouble quickfix<CR>',
      desc = 'Find quickfix',
    },
    {
      '<Leader>ft',
      ':TodoTrouble<CR>',
      desc = 'Find todos',
    },
    {
      '<Leader>fT',
      ':Trouble lsp_type_definitions<CR>',
      desc = 'Find type defintions',
    },
    {
      '<Leader>fi',
      ':Trouble lsp_implementations<CR>',
      desc = 'Find implementations',
    },
    {
      '<Leader>fc',
      ':Trouble lsp_incoming_calls<CR>',
      desc = 'Find incoming calls',
    },
    {
      'gr',
      ':Trouble lsp_references<CR>',
      desc = 'Goto references',
    },
  },
}
