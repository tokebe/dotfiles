return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('trouble').setup({
      mode = 'document_diagnostics',
    })
  end,
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
        vim.cmd('Trouble document_diagnostics')
      end,
      desc = 'Find diagnostics',
    },
    {
      '<Leader>fD',
      function()
        vim.cmd('Trouble workspace_diagnostics')
      end,
      desc = 'Find workspace diagnostics',
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