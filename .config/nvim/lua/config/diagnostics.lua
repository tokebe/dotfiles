local ns = vim.api.nvim_create_namespace('severe-diagnostics')
local original_handler = vim.diagnostic.handlers.signs

---Format diagnostics the way I like
---@param diagnostic vim.Diagnostic
local diagnostic_format = function(diagnostic)
  return string.format('%s (%s)', diagnostic.message, diagnostic.source)
end

local virt_args = {
  format = diagnostic_format,
}

-- Diagnostic signs
-- Window border style
-- Don't update in insert
-- Sort signs by severity
vim.diagnostic.config({
  virtual_text = virt_args,
  virtual_lines = false,
  float = { border = 'solid' },
  update_in_insert = false,
  severity_sort = true,
  signs = {
    -- The below doesn't seem to work for some reason, but would be more precise
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
      [vim.diagnostic.severity.HINT] = '󱉵 ',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
      [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
      [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
    },
    texthl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
      [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
      [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
    },
  },
})

local function filter_diagnostics(diagnostics)
  local most_severe = {}
  for _, current in pairs(diagnostics) do
    local max = most_severe[current.lnum]
    local is_unused_message = false

    -- Replicate behavior of zbirenbaum/neodim which is broken by this handler
    local unused_regexes = {
      '[uU]nused',
      '[nN]ever [rR]ead',
      '[nN]ot [rR]ead',
    }

    for _, regex in ipairs(unused_regexes) do
      if tostring(current.message):find(regex) ~= nil then
        is_unused_message = true
      end
    end

    if not is_unused_message and (not max or current.severity < max.severity) then
      most_severe[current.lnum] = current
      -- if not is_unused_message then -- I clearly don't understand lua logical statements
      -- end
    end
  end

  return vim.tbl_values(most_severe)
end

vim.diagnostic.handlers.signs = {
  show = function(_, bufnr, _, opts)
    local diagnostics = vim.diagnostic.get(bufnr)
    local filtered_diagnostics = filter_diagnostics(diagnostics)
    original_handler.show(ns, bufnr, filtered_diagnostics, opts)
  end,
  hide = function(_, bufnr)
    original_handler.hide(ns, bufnr)
  end,
}

vim.keymap.set('n', '<Leader>otD', function()
  local current_config = vim.diagnostic.config()
  if current_config == nil then
    return
  end

  if not current_config.virtual_text then
    vim.diagnostic.config({
      virtual_text = virt_args,
      virtual_lines = false,
    })
  else
    vim.diagnostic.config({
      virtual_text = false,
      virtual_lines = virt_args,
    })
  end
end, { silent = true, noremap = true, desc = 'Toggle detailed diagnostics' })

vim.keymap.set('n', '<Leader>otd', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, noremap = true, desc = 'Toggle LSP diagnostics' })
