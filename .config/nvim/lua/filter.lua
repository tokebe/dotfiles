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
        top = NuiText(' File Search Glob Filter ', 'Normal'),
        top_align = 'center',
        bottom = NuiText(' Enter a valid glob filter ', 'Normal'),
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
    vim.g.PersistentFilterEnabled = not vim.g.PersistentFilterEnabled
    popup.border:set_text(
      'top',
      NuiText(
        string.format(' File Search Glob Filter [%s] ', vim.g.PersistentFilterEnabled and 'enabled' or 'disabled'),
        'Normal'
      ),
      'center'
    )
  end)

  popup:mount()

  popup:on(event.BufLeave, onClose)

  local existing = vim.g.PersistentFilter or vim.g.PersistentFilterDefault or ''

  vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { existing })
end

local function getFilter()
  local filter = vim.g.PersistentFilter or vim.g.PersistentFilterDefault
  if vim.g.PersistentFilterEnabled then
    return filter
  else
    return ''
  end
end

local function toggleFilter()
  vim.g.PersistentFilterEnabled = not vim.g.PersistentFilterEnabled
  vim.notify('Persistent filter ' .. (vim.g.PersistentFilterEnabled and 'enabled' or 'disabled'))
end

return {
  setup = function(opts)
    vim.g.PersistentFilterDefault = opts.default_filter
    vim.g.PersistentFilter = vim.g.PersistentFilter or vim.g.PersistentFiltersDefault
    vim.g.PersistentFilterEnabled = true -- enabled by default

    vim.keymap.set('n', '<Leader>of', setFilter, { desc = 'Set persistent glob filter' })
    vim.keymap.set('n', '<Leader>otf', toggleFilter, { desc = 'Toggle persistent glob filter' })
  end,
  getFilter = getFilter,
}
