
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
          vim.diagnostic.config({ virtual_text = true, update_in_insert = false })
          vim.diagnostic.config({ virtual_lines = false, update_in_insert = false })
        end,
      })

      vim.keymap.set('n', '<Leader>td', function()
        lsp_lines.toggle()
        -- Remove this if lsp_lines updates to fix toggling (would cause a desync in toggling)
        vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text, update_in_insert = false })
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
