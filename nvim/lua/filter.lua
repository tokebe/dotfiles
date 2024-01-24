local buffer_to_string = function(bufnr)
  local content = vim.api.nvim_buf_get_lines(bufnr, 0, vim.api.nvim_buf_line_count(0), false)
  return table.concat(content, '\n')
end

local function setFilters()
  local NuiText = require('nui.text')
  local Popup = require('nui.popup')
  local event = require('nui.utils.autocmd').event

  local popup = Popup({
    position = '50%',
    relative = 'editor',
    size = '35%',
    enter = true,
    focusable = true,
    border = {
      style = 'rounded',
      text = {
        top = NuiText(
          string.format(' File Search Exclusions [%s] ', vim.g.PersistentFiltersEnabled and 'enabled' or 'disabled'),
          'Normal'
        ),
        top_align = 'center',
        bottom = NuiText(' Enter exclusions, separated by newlines ', 'Normal'),
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
    vim.g.PersistentFilters = buffer_to_string(popup.bufnr)
    popup:unmount()
  end

  popup:map('n', 'q', onClose, { desc = 'Close persistent filter popup' })
  popup:map('n', '<ESC>', onClose, { desc = 'Close persistent filter popup' })
  popup:map('n', 't', function()
    vim.g.PersistentFiltersEnabled = not vim.g.PersistentFiltersEnabled
    popup.border:set_text(
      'top',
      NuiText(
        string.format(' File Search Exclusions [%s] ', vim.g.PersistentFiltersEnabled and 'enabled' or 'disabled'),
        'Normal'
      ),
      'center'
    )
  end)

  popup:mount()

  popup:on(event.BufLeave, onClose)

  local existing = vim.g.PersistentFilters or vim.g.PersistentFiltersDefault or ''

  vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, vim.split(existing, '\n', { plain = true }))
end

local function formatFilter(format)
  local args = ''
  if not vim.g.PersistentFiltersEnabled then
    return args
  end
  for _, v in ipairs(vim.split(vim.g.PersistentFilters, '\n', { plain = true })) do
    if format == 'fd' then
      args = args .. string.format(" --exclude '%s'", v)
    elseif format == 'rg' then
      args = args .. string.format(" --glob '!{%s}'", v)
    else
      args = args .. string.format('\n%s', v)
    end
  end
  return args
  -- TODO format for a given type
end

return {
  setup = function(opts)
    vim.g.PersistentFiltersDefault = table.concat(opts.default_filters, '\n')
    vim.g.PersistentFilters = vim.g.PersistentFilters or vim.g.PersistentFiltersDefault

    -- FIX: seems to always be true
    if vim.g.PersistentFiltersEnabled == nil then
      if opts.enabled ~= nil then
        vim.g.PersistentFiltersEnabled = opts.enabled
      else
        vim.g.PersistentFiltersEnabled = true
      end
    end

    vim.keymap.set('n', '<Leader>of', setFilters, { desc = 'Set persistent filters' })
    vim.keymap.set('n', '<Leader>oF', function()
      vim.g.PersistentFiltersEnabled = not vim.g.PersistentFiltersEnabled
      vim.notify(
        (vim.g.PersistentFiltersEnabled and 'Enabled' or 'Disabled') .. ' persistent filter',
        vim.log.levels.INFO
      )
    end, { desc = 'Toggle persistent filters' })
  end,
  formatFilter = formatFilter,
}
