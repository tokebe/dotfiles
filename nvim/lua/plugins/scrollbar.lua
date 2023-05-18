return {
  'petertriho/nvim-scrollbar',
  config = function()
    require('scrollbar').setup({
      excluded_filetypes = require('config.filetype_excludes'),
      marks = {
        Cursor = {
          text = '',
        },
      },
      handlers = {
        gitsigns = true,
        search = true,
      },
    })
  end,
}
