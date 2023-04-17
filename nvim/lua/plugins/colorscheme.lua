-- Colorscheme(s). TODO find a way to manage/switch colorschemes
return {
  'olimorris/onedarkpro.nvim',
  dependencies = {
    'mawkler/modicator.nvim',
  },
  priority = 1000,
  config = function()
    require('onedarkpro').setup({
      options = {
        cursorline = true,
        transparency = false,
        -- highlight_inactive_windows = true,
      },
    })
    vim.cmd('colorscheme onedark')
    require('barbecue').setup({
      theme = 'onedark',
    })
    require('lualine').setup({
      options = {
        theme = 'onedark',
      },
    })
    local modicator = require('modicator')
    modicator.setup({
      -- Show warning if any required option is missing
      show_warnings = true,
      highlights = {
        -- Default options for bold/italic. You can override these individually
        -- for each mode if you'd like as seen below.
        defaults = {
          foreground = modicator.get_highlight_fg('CursorLineNr'),
          background = modicator.get_highlight_bg('CursorLineNr'),
          bold = false,
          italic = false,
        },
        -- Color and bold/italic options for each mode. You can add a bold and/or
        -- italic key pair to override the default highlight for a specific mode if
        -- you would like.
        modes = {
          ['n'] = {
            foreground = modicator.get_highlight_fg('CursorLineNr'),
          },
          ['i'] = {
            foreground = modicator.get_highlight_fg('Question'),
          },
          ['v'] = {
            foreground = modicator.get_highlight_fg('Type'),
          },
          ['V'] = {
            foreground = modicator.get_highlight_fg('Type'),
          },
          ['�'] = { -- This symbol is the ^V character
            foreground = modicator.get_highlight_fg('Type'),
          },
          ['s'] = {
            foreground = modicator.get_highlight_fg('Keyword'),
          },
          ['S'] = {
            foreground = modicator.get_highlight_fg('Keyword'),
          },
          ['R'] = {
            foreground = modicator.get_highlight_fg('Title'),
          },
          ['c'] = {
            foreground = modicator.get_highlight_fg('Constant'),
          },
        },
      },
    })
  end,
}
