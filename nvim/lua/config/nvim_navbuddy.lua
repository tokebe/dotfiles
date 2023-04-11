return {
  config = function()
    require('nvim-navbuddy').setup({
      border = 'none',
      size = '80%',
      lsp = {
        auto_attach = true,
      }
    })
    vim.keymap.set('n', '<leader>ss', '<CMD>Navbuddy<CR>', { desc = 'Select symbol' })
  end
}
