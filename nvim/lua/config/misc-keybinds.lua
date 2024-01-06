local util = require('util')

-- Format file
util.keymap('n', '<Leader>gf', function()
  vim.lsp.buf.format({ async = true })
end, { desc = 'Format file' })
util.keymap('v', '<Leader>gf', function()
  vim.lsp.buf.format({
    async = true,
    range = {
      ['start'] = vim.api.nvim_buf_get_mark(0, '<'),
      ['end'] = vim.api.nvim_buf_get_mark(0, '>'),
    },
  })
end, { desc = 'Format file' })

-- Manage Lazy plugins
util.keymap('n', '<Leader>op', ':Lazy<CR>', {
  desc = 'Manage plugins with Lazy',
})

-- Buffer/tab management
util.keymap('n', '<lt>', ':bprev<CR>', {
  desc = 'Next buffer',
})
util.keymap('n', '>', ':bnext<CR>', {
  desc = 'Previous buffer',
})
util.keymap('n', '<A-lt>', ':tabprev<CR>', {
  desc = 'Previous Tabpage',
})
util.keymap('n', '<A->>', ':tabnext<CR>', {
  desc = 'Next Tabpage',
})
util.keymap('n', '<Leader>wn', ':enew<CR>', {
  desc = 'New buffer',
})
util.keymap('n', '<Leader>wt', ':tabnew<CR>', {
  desc = 'New tabpage',
})
util.keymap('n', '<Leader>wc', ':tabclose<CR>', {
  desc = 'Close tabpage',
})

-- Session
util.keymap('n', '<Leader>qq', ':qa<CR>', {
  desc = 'Close NVIM',
})
util.keymap('n', '<Leader>qQ', ':qa!<CR>', {
  desc = 'Force close NVIM',
})

-- Movement
vim.keymap.set({ 'n', 'v', 'o' }, 'j', function()
  if vim.v.count then
    vim.api.nvim_feedkeys('gj', 'm', false)
  else
    vim.api.nvim_feedkeys('j', 'm', false)
  end
end, { expr = true })
vim.keymap.set({ 'n', 'v', 'o' }, 'k', function()
  if vim.v.count then
    vim.api.nvim_feedkeys('gk', 'm', false)
  else
    vim.api.nvim_feedkeys('k', 'm', false)
  end
end, { expr = true })

-- util.keymap({ 'n', 'v', 'o' }, 'gm', '%', {
--   desc = 'Go to match',
-- })

util.keymap({ 'n', 'v', 'o' }, 'H', function()
  local _, c = unpack(vim.api.nvim_win_get_cursor(0))
  local start, _, _ = vim.api.nvim_get_current_line():find('%S')
  if c + 1 == start then
    vim.api.nvim_feedkeys('0', 'm', false)
  else
    vim.api.nvim_feedkeys('_', 'm', false)
  end
end, {
  desc = 'Go to first char',
})
util.keymap({ 'n', 'v', 'o' }, 'L', function()
  local _, c = unpack(vim.api.nvim_win_get_cursor(0))
  local _, final, _ = vim.api.nvim_get_current_line():find('%S')
  if c + 1 == final then
    vim.api.nvim_feedkeys('g_', 'm', false)
  else
    vim.api.nvim_feedkeys('$', 'm', false)
  end
end, {
  desc = 'Go to last char',
})

-- Make Esc hide search highlight in normal mode
util.keymap('n', '<Esc>', ':noh<CR>', { noremap = true, silent = true })

-- Redo
vim.keymap.set('n', 'U', '<C-r>')

util.keymap('n', '<Leader>dd', function ()
  if vim.opt.diff:get() then
    vim.cmd('windo diffoff')
  else
    vim.cmd('windo diffthis')
  end
end, { desc = 'Diff using current split' })
