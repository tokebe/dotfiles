return {
  {
    'lewis6991/hover.nvim',
    config = function()
      local hover = require('hover')
      hover.setup({
        init = function()
          -- hover.register(multiDiagnostic)
          require('hover.providers.lsp')
          require('hover.providers.diagnostic')
          require('hover.providers.dictionary')
        end,
        preview_opts = {
          border = 'solid',
        },
        title = true,
        preview_window = true,
      })
      vim.keymap.set({ 'n' }, 'K', hover.hover, { remap = true, desc = 'Show combined hover info' })
      vim.keymap.set({ 'n' }, '<M-k>', function()
        local hover_win = vim.b.hover_preview
        if hover_win and vim.api.nvim_win_is_valid(hover_win) then
          vim.api.nvim_set_current_win(hover_win)
        end
      end, { remap = true, desc = 'Enter hover info' })
    end,
  },
  -- {
  --   'Fildo7525/pretty_hover',
  --   events = 'LspAttach',
  --   config = function()
  --     local ph = require('pretty_hover')
  --     ph.setup({
  --       border = 'shadow',
  --     })
  --
  --     vim.keymap.set({ 'n' }, 'K', function()
  --       ph.hover()
  --     end, { remap = true, desc = 'Show LSP info' })
  --     -- vim.keymap.set({ 'n' }, 'D', vim.diagnostic.open_float, { remap = true, desc = 'Show diagnostics' })
  --   end,
  -- },
}
