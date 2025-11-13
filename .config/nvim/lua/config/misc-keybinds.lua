-- Format file
vim.keymap.set('n', '<Leader>gf', function()
  vim.lsp.buf.format({ async = true })
end, { desc = 'Format file' })
vim.keymap.set('v', '<Leader>gf', function()
  vim.lsp.buf.format({
    async = true,
    range = {
      ['start'] = vim.api.nvim_buf_get_mark(0, '<'),
      ['end'] = vim.api.nvim_buf_get_mark(0, '>'),
    },
  })
end, { desc = 'Format selection' })

-- Manage Lazy plugins
vim.keymap.set('n', '<Leader>op', ':Lazy<CR>', {
  desc = 'Manage plugins with Lazy',
})

-- Buffer/tab management
vim.keymap.set('n', '<lt>', '<CMD>bprev<CR>', {
  desc = 'Next buffer',
  silent = true,
})
vim.keymap.set('n', '>', '<CMD>bnext<CR>', {
  desc = 'Previous buffer',
  silent = true,
})
vim.keymap.set('n', '<A-lt>', '<CMD>tabprev<CR>', {
  desc = 'Previous Tabpage',
  silent = true,
})
vim.keymap.set('n', '<A->>', '<CMD>tabnext<CR>', {
  desc = 'Next Tabpage',
  silent = true,
})
vim.keymap.set('n', '<S-Tab>', '<CMD>tabnext<CR>', { desc = 'Cycle Tabpages', silent = true })
vim.keymap.set('n', '<Leader>wn', '<CMD>enew<CR>', {
  desc = 'New buffer',
  silent = true,
})
vim.keymap.set('n', '<Leader>wt', '<CMD>tabnew<CR>', {
  desc = 'New tabpage',
  silent = true,
})
vim.keymap.set('n', '<Leader>wc', '<CMD>tabclose<CR>', {
  desc = 'Close tabpage',
  silent = true,
})

-- Session
vim.keymap.set('n', '<Leader>qq', '<CMD>qa<CR>', {
  desc = 'Close NVIM',
  silent = true,
})
vim.keymap.set('n', '<Leader>qQ', '<CMD>qa!<CR>', {
  desc = 'Force close NVIM',
  silent = true,
})

-- Movement
vim.keymap.set('i', '<C-l>', '<C-o>e<C-o>l')
vim.keymap.set('i', '<C-h>', '<C-o>b')

-- vim.keymap.set({ 'n', 'v', 'o' }, 'gm', '%', {
--   desc = 'Go to match',
-- })

vim.keymap.set({ 'n', 'v', 'o' }, 'H', function()
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
vim.keymap.set({ 'n', 'v', 'o' }, 'L', function()
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

-- Jumplist/Changelist
vim.keymap.set('n', 'gh', '<C-o>', { desc = 'Go back in jumplist' })
vim.keymap.set('n', 'gl', '<C-i>', { desc = 'Go forward in jumplist' })
vim.keymap.set('n', '<Leader>k', 'g;', { desc = 'Go to last change' })
vim.keymap.set('n', '<Leader>j', 'g,', { desc = 'Go to next change' })

-- Redo
vim.keymap.set('n', 'U', '<C-r>')

vim.keymap.set('n', '<Leader>dd', function()
  if vim.opt.diff:get() then
    vim.cmd('windo diffoff')
  else
    vim.cmd('windo diffthis')
  end
end, { desc = 'Diff using current split' })
