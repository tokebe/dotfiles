local ns = vim.api.nvim_create_namespace('severe-diagnostics')
local original_handler = vim.diagnostic.handlers.signs

local function filter_diagnostics(diagnostics)
  if not diagnostics then
    return
  end

  local most_severe = {}
  for _, cur in pairs(diagnostics) do
    local max = most_severe[cur.lnum]
    if not max or cur.severity < max.severity then
      most_severe[cur.lnum] = cur
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

return {
  -- { -- Disabled until it can be set to ignore certain file types
  --   'dgagn/diagflow.nvim',
  --   event = 'LspAttach',
  --   config = function()
  --     require('diagflow').setup({
  --       padding_right = 5,
  --       scope = 'line',
  --       show_sign = true,
  --       gap_size = 1,
  --       update_event = { 'DiagnosticChanged' },
  --       format = function(diagnostic)
  --         return diagnostic.message .. '  ' .. diagnostic.col
  --       end,
  --       enable = function()
  --         local disabled = false
  --         for _, v in pairs(require('config.filetype_excludes')) do
  --           if v == vim.bo.filetype then
  --             disabled = true
  --           end
  --         end
  --         return not disabled
  --       end,
  --     })
  --   end,
  -- },
}
