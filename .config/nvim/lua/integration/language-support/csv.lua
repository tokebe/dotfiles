return {
  {
    'hat0uma/csvview.nvim',
    config = function()
      local csv = require('csvview')
      require('csvview').setup({
        view = {
          display_mode = 'highlight',
        },
      })
      vim.keymap.set('n', '<Leader>otS', function()
        csv.toggle()
        vim.opt.wrap = not vim.opt.wrap
      end, { desc = 'Toggle csv view' })
    end,
  },
}
