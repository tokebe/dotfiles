local remove_keymap = function()
  local internal = require('detour.internal')
  if next(internal.list_popups()) == nil then
    vim.keymap.del('n', 'q')
    vim.keymap.del('n', '<CR>')
  end
end

local add_keymap = function()
  local utils = require('detour.util')
  vim.keymap.set('n', 'q', function()
    pcall(vim.api.nvim_win_close, utils.find_top_popup(), true)
    remove_keymap()
  end)
  vim.keymap.set('n', 'Q', function()
    local _ = require('detour.features').CloseCurrentStack()
  end)
  vim.keymap.set('n', '<CR>', function()
    local popup_id = utils.find_top_popup()
    local buf = vim.api.nvim_win_get_buf(popup_id)
    local file = vim.api.nvim_buf_get_name(buf)
    local r, c = unpack(vim.api.nvim_win_get_cursor(popup_id))
    local _ = require('detour.features').CloseCurrentStack()
    vim.cmd('e! ' .. file)
    vim.api.nvim_win_set_cursor(0, { r, c })
    remove_keymap()
  end)
end

local early_escape_action = function(popup_id)
  return {
    ['esc'] = function()
      pcall(vim.api.nvim_win_close, popup_id, true)
    end,
  }
end

local picker_defaults = function(popup_id, height)
  return {
    actions = early_escape_action(popup_id),
    winopts = {
      height = height or 0.3,
      width = 0.9,
      row = 0.9,
      preview = {
        layout = 'vertical',
        vertical = 'up',
      },
    },
  }
end

-- TODO: don't detour if exiting fzf
local pick_and_detour = function(fzf_func, height)
  return function()
    local detour = require('detour')
    local features = require('detour.features')
    local popup_id = detour.DetourCurrentWindow()
    if not popup_id then
      return
    end
    features.ShowPathInTitle(popup_id)
    fzf_func(picker_defaults(popup_id, height))
    add_keymap()
  end
end

return {
  {
    'carbon-steel/detour.nvim',
    dependencies = { 'ibhagwan/fzf-lua' },
    config = function()
      local fzf = require('fzf-lua')
      vim.keymap.set('n', 'gd', pick_and_detour(fzf.lsp_definitions), { desc = 'Preview definition(s)' })
      vim.keymap.set('n', 'gt', pick_and_detour(fzf.lsp_typedefs), { desc = 'Preview type definitions(s)' })
      vim.keymap.set('n', 'gT', pick_and_detour(fzf.lsp_declarations), { desc = 'Preview declaration(s)' })
      -- vim.keymap.set(
      --   'n',
      --   'fd',
      --   pick_and_detour(fzf.lsp_document_diagnostics, 0.95),
      --   { desc = 'Find document diagnostics' }
      -- )
      -- vim.keymap.set(
      --   'n',
      --   'fD',
      --   pick_and_detour(fzf.lsp_workspace_diagnostics, 0.95),
      --   { desc = 'Find workspace diagnostics' }
      -- )
      vim.keymap.set('n', '<Leader>fi', pick_and_detour(fzf.lsp_implementations), { desc = 'Find implementations' })
      -- vim.keymap.set('n', '<leader>mf', function()
      --   local window_id = require('detour').Detour() -- open a detour
      --   if not window_id then
      --     return
      --   end
      --
      --   vim.cmd.terminal('lf') -- open a terminal buffer
      --   vim.bo.bufhidden = 'delete' -- close the terminal when window closes
      --   vim.wo[window_id].signcolumn = 'no' -- In Neovim 0.10, the signcolumn can push the TUI a bit out of window
      --
      --   -- It's common for people to have `<Esc>` mapped to `<C-\><C-n>` for terminals.
      --   -- This can get in the way when interacting with TUIs.
      --   -- This maps the escape key back to itself (for this buffer) to fix this problem.
      --   vim.keymap.set('t', '<Esc>', '<Esc>', { buffer = true })
      --
      --   vim.cmd.startinsert() -- go into insert mode
      --
      --   vim.api.nvim_create_autocmd({ 'TermClose' }, {
      --     buffer = vim.api.nvim_get_current_buf(),
      --     callback = function()
      --       -- This automated keypress skips for you the "[Process exited 0]" message
      --       -- that the embedded terminal shows.
      --       vim.api.nvim_feedkeys('i', 'n', false)
      --     end,
      --   })
      -- end)
    end,
  },
  -- {
  --   'DNLHC/glance.nvim',
  --   keys = {
  --     { 'gd', '<CMD>Glance definitions<CR>' },
  --   },
  -- },
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
}
