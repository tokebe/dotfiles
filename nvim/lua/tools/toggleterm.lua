return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup({
      open_mapping = [[<C-Space>]],
    })
    local util = require('util')
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]])
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]])
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]])
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]])
    vim.keymap.set('t', '<C-M-Space>', [[<C-\><C-n>]])

    vim.keymap.set('n', '<Leader>tt', ':999ToggleTerm direction=float<CR>', {
      desc = 'Toggle dedicated floating terminal',
    })
  end,
}
