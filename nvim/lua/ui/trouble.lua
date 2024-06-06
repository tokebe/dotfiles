return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('trouble').setup({
      mode = 'document_diagnostics',
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
      '<S-Tab>',
      ':tabnext<CR>',
      desc = 'Switch tabs',
    },
    {
      '<Leader>fd',
      function()
        vim.cmd('Trouble diagnostics')
      end,
      desc = 'Find diagnostics',
    },
    {
      '<Leader>fq',
      function()
        vim.cmd('Trouble quickfix')
      end,
      desc = 'Find quickfix',
    },
    {
      '<Leader>ft',
      function()
        vim.cmd('TodoTrouble')
      end,
      desc = 'Find todos',
    },
  },
}
