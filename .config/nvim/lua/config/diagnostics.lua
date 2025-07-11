local ns = vim.api.nvim_create_namespace('severe-diagnostics')
local original_handler = vim.diagnostic.handlers.signs

-- Diagnostic signs
-- Window border style
-- Don't update in insert
-- Sort signs by severity
vim.diagnostic.config({
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
