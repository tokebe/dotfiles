return {
  'petertriho/nvim-scrollbar',
  config = function ()
    require('scrollbar').setup({
      excluded_filetypes = require('config.filetype_excludes'),
      handlers = {
        gitsigns = true,
      }
    })
  end
}
