local specialFiles = {
  'TelescopePrompt',
  'TelescopeResults',
  'Trouble',
  'help',
  'DressingSelect',
  'NvimTree',
  'mason',
  'null-ls-info',
  'lazy',
}
return {
  -- Highlight and auto-delete whitespace
  'johnfrankmorgan/whitespace.nvim',
  config = function()
    local whitespace = require('whitespace-nvim')
    whitespace.setup({
      ignored_filetypes = specialFiles
    })
    vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
      callback = function()
        local fileIsReadOnly = vim.bo[vim.api.nvim_win_get_buf(0)].readonly
        local fileIsSpecial = specialFiles[vim.bo.filetype] ~= nil
        local fileIsModifiable = vim.bo.modifiable
        if not fileIsReadOnly and not fileIsSpecial and fileIsModifiable then
          whitespace.trim()
        end
      end
    })
  end
}
