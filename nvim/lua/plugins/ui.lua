return {
  {
    'kosayoda/nvim-lightbulb',
    config = function()
      require('nvim-lightbulb').setup({
        sign = {
          enabled = false,
        },
        status_text = {
          enabled = true,
          text = '󱉵',
        },
        autocmd = {
          enabled = true,
        },
      })
    end,
  },
  {
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
  },
}
