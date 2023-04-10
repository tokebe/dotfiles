return {
  -- Highlight and auto-delete whitespace
  'johnfrankmorgan/whitespace.nvim',
  config = function()
    local whitespace = require('whitespace-nvim')
    whitespace.setup({
      ignored_filetypes = {
        'TelescopePrompt',
        'TelescopeResults',
        'Trouble',
        'help',
        'DressingSelect',
        'NvinTree',
      }
    })
    vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
      callback = function()
        if not vim.bo[vim.api.nvim_win_get_buf(0)].readonly then
          whitespace.trim()
        end
      end
    })
  end
}
