return { -- Command completion, I honestly don't know how it works.
  'gelguy/wilder.nvim', -- I'd honestly go back to cmp_cmdline if I could get it to work
  dependencies = {
    { 'nvim-tree/nvim-web-devicons' },
    { 'romgrk/fzy-lua-native' },
  },
  event = 'CmdLineEnter',
  config = function()
    local wilder = require('wilder')
    wilder.setup({modes = {':', '/', '?'}})
    -- Disable Python remote plugin
    wilder.set_option('use_python_remote_plugin', 0)

    wilder.set_option('pipeline', {
      wilder.branch(
        wilder.cmdline_pipeline({
          fuzzy = 1,
          fuzzy_filter = wilder.lua_fzy_filter(),
        }),
        wilder.vim_search_pipeline()
      )
    })

    wilder.set_option('renderer', wilder.renderer_mux({
      [':'] = wilder.popupmenu_renderer({
        highlighter = wilder.lua_fzy_highlighter(),
        left = {
          ' ',
          wilder.popupmenu_devicons()
        },
        right = {
          ' ',
          wilder.popupmenu_scrollbar()
        },
      }),
      ['/'] = wilder.wildmenu_renderer({
        highlighter = wilder.lua_fzy_highlighter(),
      }),
    }))
  end
}
