local filetype_excludes = require('config.filetype_excludes')

return {
  -- Highlight and auto-delete whitespace
  'johnfrankmorgan/whitespace.nvim',
  config = function()
    local whitespace = require('whitespace-nvim')
    whitespace.setup({
      ignored_filetypes = filetype_excludes
    })
    vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
      callback = function()
        local fileIsReadOnly = vim.bo[vim.api.nvim_win_get_buf(0)].readonly
        local fileIsSpecial = filetype_excludes[vim.bo.filetype] ~= nil
        local fileIsModifiable = vim.bo.modifiable
        if not fileIsReadOnly and not fileIsSpecial and fileIsModifiable then
          whitespace.trim()
        end
      end
    })
  end
}
