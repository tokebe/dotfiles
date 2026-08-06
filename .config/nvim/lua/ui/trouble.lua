return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  -- Track main: the nvim 0.12 `_on_range` highlighter fix isn't in a 3.x tag yet.
  -- Revert to version = '3.*.*' once a release > v3.7.1 ships.
  branch = 'main',
  opts = {
    focus = true,
  },
  event = 'LspAttach',
  keys = {
    -- {
    --   '<Leader>fq',
    --   ':Trouble quickfix<CR>',
    --   desc = 'Find quickfix',
    -- },
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
