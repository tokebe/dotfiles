-- vim.api.nvim_create_autocmd('ModeChanged', {
--   pattern = '*',
--   callback = function()
--     if
--       (
--         (vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n')
--         or (vim.v.event.old_mode == 'i' and vim.v.event.new_mode ~= 's')
--       )
--       and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
--       and not require('luasnip').session.jump_active
--     then
--       require('luasnip').unlink_current()
--     end
--   end,
--   desc = 'Prevent luasnip from jumping back after finishing a snippet',
-- })

vim.api.nvim_create_autocmd('FocusGained', {
  desc = 'Reload files from disk when we focus vim',
  pattern = '*',
  command = "if getcmdwintype() == '' | checktime | endif",
})
vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Every time we enter an unmodified buffer, check if it changed on disk',
  pattern = '*',
  command = "if &buftype == '' && !&modified && expand('%') != '' | exec 'checktime ' . expand('<abuf>') | endif",
})
