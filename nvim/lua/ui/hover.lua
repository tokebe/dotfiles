return {
  {
    'lewis6991/hover.nvim',
    commit = "f74d2924564ba5fd8faa2d7e7cf6065de26f9820",
    config = function()
      local multiDiagnostic = {
        name = 'multiDiagnostic',
        priority = 1000,
        enabled = function()
          return true
        end,
        execute = function(done)
          local util = vim.lsp.util
          local params = util.make_position_params()
          local _, cur_col = unpack(vim.api.nvim_win_get_cursor(0))
          local severity = { ' ', ' ', ' ', '󱉵 ' }
          vim.lsp.buf_request_all(0, 'textDocument/hover', params, function(responses)
            local value = ' '
            local _, row = unpack(vim.fn.getpos('.'))
            local lineDiag = vim.diagnostic.get(0, { lnum = row - 1 })
            local hadDiagnostics = false
            for _, d in pairs(lineDiag) do
              local under_cur = cur_col >= d.col and (d.end_col == nil or cur_col <= d.end_col)
              if under_cur and d.message then
                if not hadDiagnostics then
                  hadDiagnostics = true
                  value = value .. 'Diagnostics:'
                end
                for i, str in ipairs(vim.split(d.message, '\n', { plain = true })) do
                  if i == 1 then
                    value = value .. string.format('\n  %s %s: %s', severity[d.severity], d.source, str)
                  else
                    value = value .. string.format('\n   %s', str)
                  end
                end
                value = value .. string.format(' \\[%s\\]', d.code)
              end
            end
            value = value:gsub('\r', '')
            if hadDiagnostics then
              value = value .. '\n---'
            end

            for _, response in pairs(responses) do
              local result = response.result
              if result and result.contents and result.contents.value then
                if value ~= '' then
                  value = value .. '\n'
                end
                value = value .. result.contents.value
              end
            end

            if value:match('^%s*$') then
              value = 'No information found.'
            end
            if value ~= ' ' then
              done({ lines = vim.split(value, '\n', { plain = true }), filetype = 'markdown' })
            else
              done()
            end
          end)
        end,
      }

      local hover = require('hover')
      hover.setup({
        init = function()
          hover.register(multiDiagnostic)
        end,
        preview_opts = {
          border = 'shadow',
        },
        title = false,
      })
      vim.keymap.set({ 'n' }, 'K', require('hover').hover, { remap = true, desc = 'Show combined hover info' })
    end,
  },
}
