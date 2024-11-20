return {
  {
    'stevearc/dressing.nvim',
    config = function()
      require('dressing').setup({
        input = {
          win_options = {
            winhighlight = 'NormalFloat:Normal,FloatBorder:Normal,FloatTitle:Normal,CursorLine:Normal',
          },
          border = 'single',
          override = function(conf)
            conf.col = -1
            conf.row = 0
            return conf
          end,
          -- border = 'none',
        },
      })
    end,
  },
}
