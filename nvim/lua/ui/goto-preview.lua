local util = require('util')
return {
  {
    'rmagatti/goto-preview',
    config = function()
      local gp = require('goto-preview')
      gp.setup({
        post_open_hook = function(buff, win)
          vim.keymap.set('n', 'q', function()
            if vim.api.nvim_win_is_valid(win) then
              vim.api.nvim_win_close(win, true)
            end
          end, { buffer = buff })
          vim.keymap.set('n', '<CR>', function()
            local file = vim.api.nvim_buf_get_name(buff)
            gp.close_all_win({ skip_curr_window = false })
            vim.cmd('e! ' .. file)
            vim.api.nvim_buf_del_keymap(buff, 'n', '<CR>')
            vim.api.nvim_buf_del_keymap(buff, 'n', 'q')
          end, { buffer = buff })
          vim.api.nvim_create_autocmd({ 'WinResized' }, {
            description = 'Disable special keybinds when preview moved',
            callback = function(event)
              vim.api.nvim_buf_del_keymap(buff, 'n', '<CR>')
              vim.api.nvim_buf_del_keymap(buff, 'n', 'q')
              return true
            end,
          })
        end,
      })
      util.keymap('n', 'gd', gp.goto_preview_definition)
      util.keymap('n', 'gt', gp.goto_preview_type_definition)
      util.keymap('n', 'gT', gp.goto_preview_declaration)
    end,
  },
}