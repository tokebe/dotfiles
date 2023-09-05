return {
  {
    'm-demare/hlargs.nvim',
    config = function()
      require('hlargs').setup()
    end,
  },
  {
    'zbirenbaum/neodim',
    event = 'LspAttach',
    config = function()
      require('neodim').setup({
        alpha = 0.75,
        blend_color = '#000000',
        update_in_insert = {
          enable = false,
        },
        hide = {
          virtual_text = true,
          signs = true,
          underline = true,
        },
      })
    end,
  },
  {
    'folke/todo-comments.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('todo-comments').setup({
        highlight = {
          pattern = [[.*<(KEYWORDS)>\s*:?]],
        },
        search = {
          pattern = [[\b(KEYWORDS):?]],
        },
      })
    end,
  },
  {
    'fei6409/log-highlight.nvim',
    config = function()
      require('log-highlight').setup({
        extension = 'log',
        filename = {
          'messages',
        },
      })
    end,
  },
  {
    'jinh0/eyeliner.nvim',
    config = function()
      require('eyeliner').setup({
        highlight_on_key = true,
      })
    end,
  },
  -- { -- Too little contrast for selection in visual mode and can't disable
  --   'mvllow/modes.nvim',
  --   config = function()
  --     require('modes').setup({
  --       ignore_filetypes = require('config.filetype_excludes'),
  --       set_cursorline = false, -- doesn't seem to work
  --       set_number = true,
  --     })
  --   end,
  -- },
}
