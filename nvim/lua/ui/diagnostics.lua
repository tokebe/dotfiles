local ns = vim.api.nvim_create_namespace('severe-diagnostics')
local original_handler = vim.diagnostic.handlers.signs

-- Diagnostic signs
vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = '󱉵 ', texthl = 'DiagnosticSignHint' })

-- Window border style
vim.diagnostic.config({ float = { border = 'solid' } })

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

return {
  {
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    events = 'LspAttach',
    config = function()
      local lsp_lines = require('lsp_lines')
      lsp_lines.setup({})

      -- Disable by default
      vim.api.nvim_create_autocmd('BufEnter', {
        callback = function()
          vim.diagnostic.config({ virtual_text = true })
          vim.diagnostic.config({ virtual_lines = false })
        end,
      })

      vim.keymap.set('n', '<Leader>td', function()
        lsp_lines.toggle()
        -- Remove this if lsp_lines updates to fix toggling (would cause a desync in toggling)
        vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
      end, { remap = true, desc = 'Toggle diagnostic detail' })
    end,
  },
  -- { -- I prefer to see all diagnostics together
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
