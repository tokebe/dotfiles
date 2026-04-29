-- Command palette: fuzzy over live commands + normal-mode keymaps.
-- Source of truth is nvim itself (nvim_get_commands / nvim_get_keymap), so anything
-- declared with a `desc` anywhere — lazy keys, vim.keymap.set, util.keymap,
-- nvim_create_user_command — shows up automatically. No registration list to drift.

local function cmd_desc(info)
  -- nvim 0.11+ surfaces `desc`; older / vimscript commands fall back to definition.
  if info.desc and info.desc ~= '' then
    return info.desc
  end
  return info.definition or ''
end

local function gather()
  local items = {}

  for name, info in pairs(vim.api.nvim_get_commands({})) do
    items[#items + 1] = { kind = 'cmd', name = name, desc = cmd_desc(info) }
  end
  for name, info in pairs(vim.api.nvim_buf_get_commands(0, {})) do
    items[#items + 1] = { kind = 'cmd', name = name, desc = cmd_desc(info), buf = true }
  end

  -- Normal-mode only: palette is for "pick an action and run it"; visual/insert
  -- bindings depend on entry mode and don't behave on dispatch from a picker.
  for _, m in ipairs(vim.api.nvim_get_keymap('n')) do
    if m.desc and m.desc ~= '' then
      items[#items + 1] = { kind = 'key', lhs = m.lhs, desc = m.desc }
    end
  end
  for _, m in ipairs(vim.api.nvim_buf_get_keymap(0, 'n')) do
    if m.desc and m.desc ~= '' then
      items[#items + 1] = { kind = 'key', lhs = m.lhs, desc = m.desc, buf = true }
    end
  end

  return items
end

local function format_item(item)
  local marker = item.buf and '*' or ' '
  if item.kind == 'cmd' then
    local desc = item.desc:gsub('%s+', ' ')
    if #desc > 80 then
      desc = desc:sub(1, 77) .. '...'
    end
    return string.format('cmd%s :%-28s  %s', marker, item.name, desc)
  end
  return string.format('key%s %-29s  %s', marker, item.lhs, item.desc)
end

local function open()
  local items = gather()
  local lines = {}
  local lookup = {}
  for _, item in ipairs(items) do
    local line = format_item(item)
    lines[#lines + 1] = line
    lookup[line] = item
  end
  table.sort(lines)

  require('fzf-lua').fzf_exec(lines, {
    prompt = 'Palette> ',
    previewer = 'none',
    winopts = {
      height = 0.5,
      width = 0.9,
      row = 0.9,
    },
    actions = {
      ['default'] = function(selected)
        local item = lookup[selected and selected[1] or '']
        if not item then
          return
        end
        if item.kind == 'cmd' then
          -- Trailing space so the user can pass args before <CR>.
          vim.api.nvim_feedkeys(':' .. item.name .. ' ', 'n', false)
        else
          local keys = vim.api.nvim_replace_termcodes(item.lhs, true, false, true)
          vim.api.nvim_feedkeys(keys, 'm', false)
        end
      end,
    },
  })
end

vim.keymap.set('n', '<Leader><Leader>', function()
  open()
end, { desc = 'Command palette (commands + keymaps)' })
return {}
