return {
  -- Highlight and auto-delete whitespace
  'johnfrankmorgan/whitespace.nvim',
  config = function()
    local whitespace = require('whitespace-nvim')
    whitespace.setup()
    vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
      callback = function()
        whitespace.trim()
      end
    })
  end
}
