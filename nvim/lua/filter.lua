local buffer_to_string = function(bufnr)
  local content = vim.api.nvim_buf_get_lines(bufnr, 0, vim.api.nvim_buf_line_count(0), false)
  return table.concat(content, '\n')
end

local function setFilter()
  local NuiText = require('nui.text')
  local Popup = require('nui.popup')
  local event = require('nui.utils.autocmd').event

  local popup = Popup({
    position = '50%',
    relative = 'editor',
    size = {
      width = '35%',
      height = '10%',
    },
    enter = true,
    focusable = true,
    border = {
      style = 'rounded',
      text = {
        top = NuiText(' File Search Grep Filter ', 'Normal'),
        top_align = 'center',
        bottom = NuiText(' Enter a valid grep filter ', 'Normal'),
        bottom_align = 'left',
      },
    },
    win_options = {
      winhighlight = 'Normal:Normal,FloatBorder:Normal',
    },
    buf_options = {
      modifiable = true,
      readonly = false,
      filetype = 'persistantfilterdata',
    },
  })

  local function onClose()
    vim.g.PersistentFilter = buffer_to_string(popup.bufnr)
    popup:unmount()
  end

  popup:map('n', 'q', onClose, { desc = 'Close persistent filter popup' })
  popup:map('n', '<ESC>', onClose, { desc = 'Close persistent filter popup' })
  popup:map('n', 't', function()
    popup.border:set_text('top', NuiText(' File Search Exclusions [%s] ', 'Normal'), 'center')
  end)

  popup:mount()

  popup:on(event.BufLeave, onClose)

  local existing = vim.g.PersistentFilter or vim.g.PersistentFilterDefault or ''

  vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, {existing})
end

-- local function formatFilter(format)
--   local args = ''
--   for _, v in ipairs(vim.split(vim.g.PersistentFilter, '\n', { plain = true })) do
--     if format == 'fd' then
--       args = args .. string.format(" --exclude '%s'", v)
--     elseif format == 'rg' then
--       args = args .. string.format(" --glob '!{%s}'", v)
--     else
--       args = args .. string.format('\n%s', v)
--     end
--   end
--   return args
--   -- TODO format for a given type
-- end

local function getFilter()
  return vim.g.PersistentFilter
end

return {
  setup = function(opts)
    vim.g.PersistentFilterDefault = opts.default_filter
    vim.g.PersistentFilter = vim.g.PersistentFilter or vim.g.PersistentFiltersDefault

    vim.keymap.set('n', '<Leader>of', setFilter, { desc = 'Set persistent glob filter' })
  end,
  getFilter = getFilter,
}
