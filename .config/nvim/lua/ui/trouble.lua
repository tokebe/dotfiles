return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    focus = true,
  },
  event = 'LspAttach',
  keys = {
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
      'gr',
      ':Trouble lsp_references<CR>',
      desc = 'Goto references',
    },
    {
      '<Leader>fc',
      ':Trouble lsp_incoming_calls<CR>',
      desc = 'Find incoming calls',
    },
    {
      '<Leader>fC',
      ':Trouble lsp_outgoing_calls<CR>',
      desc = 'Find outgoing calls',
    },
    {
      '<Leader>fd',
      ':Trouble diagnostics filter.buf=0<CR>',
      desc = 'Find diagnostics',
    },
    {
      '<Leader>fD',
      ':Trouble diagnostics<CR>',
      desc = 'Find diagnostics',
    },
  },
}
