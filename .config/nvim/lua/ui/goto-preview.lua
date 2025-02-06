local remove_keymap = function()
  local internal = require('detour.internal')
  if next(internal.list_popups()) == nil then
    vim.keymap.del('n', 'q')
    vim.keymap.del('n', '<CR>')
  end
end

local add_keymap = function()
  local internal = require('detour.internal')
  local utils = require('detour.util')
  vim.keymap.set('n', 'q', function()
    pcall(vim.api.nvim_win_close, utils.find_top_popup(), true)
    remove_keymap()
  end)
  vim.keymap.set('n', '<CR>', function()
    local popup_id = utils.find_top_popup()
    local buf = vim.api.nvim_win_get_buf(popup_id)
    local file = vim.api.nvim_buf_get_name(buf)
    local r, c = unpack(vim.api.nvim_win_get_cursor(popup_id))
    for _, popup in ipairs(internal.list_popups()) do
      pcall(vim.api.nvim_win_close, popup, true)
    end
    vim.cmd('e! ' .. file)
    vim.api.nvim_win_set_cursor(0, { r, c })
    remove_keymap()
  end)
end

return {
  -- {
  --   'rmagatti/goto-preview',
  --   config = function()
  --     local gp = require('goto-preview')
  --     gp.setup({
  --       post_open_hook = function(buff, win)
  --         vim.keymap.set('n', 'q', function()
  --           if vim.api.nvim_win_is_valid(win) then
  --             vim.api.nvim_win_close(win, true)
  --           end
  --         end, { buffer = buff })
  --         vim.keymap.set('n', '<CR>', function()
  --           local file = vim.api.nvim_buf_get_name(buff)
  --           gp.close_all_win({ skip_curr_window = false })
  --           vim.cmd('e! ' .. file)
  --           vim.api.nvim_buf_del_keymap(buff, 'n', '<CR>')
  --           vim.api.nvim_buf_del_keymap(buff, 'n', 'q')
  --         end, { buffer = buff })
  --         vim.api.nvim_create_autocmd({ 'WinResized' }, {
  --           description = 'Disable special keybinds when preview moved',
  --           callback = function(event)
  --             vim.api.nvim_buf_del_keymap(buff, 'n', '<CR>')
  --             vim.api.nvim_buf_del_keymap(buff, 'n', 'q')
  --             return true
  --           end,
  --         })
  --       end,
  --     })
  --     vim.keymap.set('n', 'gd', gp.goto_preview_definition)
  --     vim.keymap.set('n', 'gT', gp.goto_preview_declaration)
  --     vim.keymap.set('n', 'gt', gp.goto_preview_type_definition)
  --   end,
  -- },
  {
    'carbon-steel/detour.nvim',
    config = function()
      local detour = require('detour')
      local features = require('detour.features')
      vim.keymap.set('n', 'gd', function()
        local popup_id = detour.DetourCurrentWindow()
        if not popup_id then
          return
        end
        features.ShowPathInTitle(popup_id)
        vim.lsp.buf.definition({ reuse_win = false })
        add_keymap()
      end)

      vim.keymap.set('n', 'gD', function()
        local popup_id = detour.DetourCurrentWindow()
        if not popup_id then
          return
        end
        features.ShowPathInTitle(popup_id)
        vim.lsp.buf.declaration({ reuse_win = false })
        add_keymap()
      end)

      vim.keymap.set('n', 'gT', function()
        local popup_id = detour.DetourCurrentWindow()
        if not popup_id then
          return
        end
        features.ShowPathInTitle(popup_id)
        vim.lsp.buf.declaration({ reuse_win = false })
        add_keymap()
      end)

      vim.keymap.set('n', 'gt', function()
        local popup_id = detour.DetourCurrentWindow()
        if not popup_id then
          return
        end
        features.ShowPathInTitle(popup_id)
        vim.lsp.buf.type_definition({ reuse_win = false })
        add_keymap()
      end)
    end,
  },
}
