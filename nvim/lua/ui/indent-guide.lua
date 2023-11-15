return {
  -- Add indentation guides even on blank lines
  'lukas-reineke/indent-blankline.nvim',
  event = 'BufEnter',
  config = function()
    local highlight = {
      'CursorColumn',
      'Whitespace',
    }
    require('ibl').setup({
      indent = {
        char = '│',
        -- char = '',
        -- highlight = highlight,
      },
      whitespace = {
        -- highlight = highlight,
      },
      exclude = {
        filetypes = require('config.filetype_excludes'),
      },
    })
  end,
}
