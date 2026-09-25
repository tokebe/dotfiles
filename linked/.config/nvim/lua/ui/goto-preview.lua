local remove_keymap = function()
  local internal = require('detour.internal')
  if next(internal.list_popups()) == nil then
    vim.keymap.del('n', 'q')
    vim.keymap.del('n', '<CR>')
  end
end

local add_keymap = function()
  local utils = require('detour.util')
  -- nowait: skip timeoutlen wait from global q: -> <nop> mapping
  vim.keymap.set('n', 'q', function()
    pcall(vim.api.nvim_win_close, utils.find_top_popup(), true)
    remove_keymap()
  end, { nowait = true })
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

local picker_defaults = function(height)
  return {
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

---@diagnostic disable-next-line: deprecated
local is_list = vim.islist or vim.tbl_islist

local open_detour_to = function(open_target)
  local detour = require('detour')
  local features = require('detour.features')
  local popup_id = detour.DetourCurrentWindow()
  if not popup_id then
    return
  end
  features.ShowPathInTitle(popup_id)
  open_target()
  add_keymap()
end

-- Detour inside the action instead of before fzf so cancel doesn't open detour
local pick_and_detour = function(fzf_func, lsp_method, height)
  return function()
    local open_in_detour = function(selected, sel_opts)
      if not selected or #selected == 0 then
        return
      end
      open_detour_to(function()
        require('fzf-lua.actions').file_edit_or_qf(selected, sel_opts)
      end)
    end
    local launch_picker = function()
      local opts = picker_defaults(height)
      -- async: bypass fzf-lua's default sync LSP path (5s block on slow servers)
      opts.async = true
      -- fzf gives two paths (selection and bypass for single-result)
      -- Have to override both
      opts.actions = { ['default'] = open_in_detour }
      opts.jump1_action = open_in_detour
      fzf_func(opts)
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr, method = lsp_method })
    if #clients == 0 then
      -- No LSP support: let fzf-lua handle the error messaging
      launch_picker()
      return
    end

    -- ### Some defered magic to avoid fzf showing briefly if there's only 1 target
    local resolved = false
    local encoding = clients[1].offset_encoding
    local params = vim.lsp.util.make_position_params(0, encoding)

    -- If unresolved after timeout, open fzf
    vim.defer_fn(function()
      if resolved then
        return
      end
      resolved = true
      launch_picker()
    end, 200)

    -- Get the lsp options fzf would get, if only 1, skip fzf
    vim.lsp.buf_request_all(bufnr, lsp_method, params, function(results)
      if resolved then
        return
      end
      local locations = {}
      for _, res in pairs(results) do
        if res.result then
          if is_list(res.result) then
            vim.list_extend(locations, res.result)
          elseif next(res.result) then
            table.insert(locations, res.result)
          end
        end
      end
      if #locations ~= 1 then
        return
      end
      resolved = true
      open_detour_to(function()
        vim.lsp.util.show_document(locations[1], encoding, { focus = true })
      end)
    end)
  end
end

return {
  {
    'carbon-steel/detour.nvim',
    dependencies = { 'ibhagwan/fzf-lua' },
    config = function()
      local fzf = require('fzf-lua')
      vim.keymap.set(
        'n',
        'gd',
        pick_and_detour(fzf.lsp_definitions, 'textDocument/definition'),
        { desc = 'Preview definition(s)' }
      )
      vim.keymap.set(
        'n',
        'gt',
        pick_and_detour(fzf.lsp_typedefs, 'textDocument/typeDefinition'),
        { desc = 'Preview type definitions(s)' }
      )
      vim.keymap.set(
        'n',
        'gT',
        pick_and_detour(fzf.lsp_declarations, 'textDocument/declaration'),
        { desc = 'Preview declaration(s)' }
      )
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
      vim.keymap.set(
        'n',
        '<Leader>fi',
        pick_and_detour(fzf.lsp_implementations, 'textDocument/implementation'),
        { desc = 'Find implementations' }
      )
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
