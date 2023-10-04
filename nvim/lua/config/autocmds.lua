vim.api.nvim_create_autocmd('ModeChanged', {
  pattern = '*',
  callback = function()
    if
        ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
        and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require('luasnip').session.jump_active
    then
      require('luasnip').unlink_current()
    end
  end,
  desc = 'Prevent luasnip from jumping back after finishing a snippet',
})

vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI', 'BufEnter', 'FocusGained' }, {
  pattern = '*',
  callback = function()
    vim.cmd('checktime')
  end,
  desc = 'Check for file changes periodically',
})

