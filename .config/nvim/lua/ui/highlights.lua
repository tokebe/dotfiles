return {
  {
    -- Auto-delete whitespace on write (would highlight, but autosave auto-cleans it)
    'kaplanz/retrail.nvim',
    config = function()
      require('retrail').setup({
        hlgroup = 'DiffDelete',
        filetype = {
          exclude = require('config.filetype_excludes'),
        },
        trim = { auto = false },
      })
      vim.keymap.set('n', '<Leader>gw', '<CMD>RetrailTrimWhitespace<CR>', { desc = 'Trim whitespace' })
    end,
  },
  {
    'm-demare/hlargs.nvim',
    config = function()
      require('hlargs').setup()
    end,
  },
  -- { -- Causes way too many errors when major file changes occur
  --   'zbirenbaum/neodim',
  --   event = 'LspAttach',
  --   config = function()
  --     require('neodim').setup({
  --       alpha = 0.75,
  --       blend_color = '#000000',
  --       update_in_insert = {
  --         enable = false,
  --       },
  --       hide = {
  --         virtual_text = true,
  --         signs = true,
  --         underline = true,
  --       },
  --     })
  --   end,
  -- },
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
  {
    'kevinhwang91/nvim-hlslens',
    dependencies = {
      'kevinhwang91/nvim-ufo',
    },
    config = function()
      require('hlslens').setup({
        calm_down = true,
      })
      local kopts = { noremap = true, silent = true }

      vim.keymap.set(
        'n',
        'n',
        [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts
      )
      vim.keymap.set(
        'n',
        'N',
        [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts
      )
      vim.keymap.set('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.keymap.set('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.keymap.set('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.keymap.set('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.keymap.set('n', '<Esc>', '<Cmd>nohl<CR>', kopts)
    end,
  },
  { -- underdot occurances of symbol
    'RRethy/vim-illuminate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('illuminate').configure({
        filetypes_denylist = require('config.filetype_excludes'),
        under_cursor = false,
      })
      vim.api.nvim_set_hl(0, 'IlluminatedWordText', { underdotted = true })
      vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { underdotted = true })
      vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { underdotted = true })
    end,
  },
  { -- highlight occurances of word
    'echasnovski/mini.cursorword',
    config = function()
      require('mini.cursorword').setup()
    end,
  },
  { -- highlight occurances of visual selection
    'wurli/visimatch.nvim',
    opts = {
      hl_group = 'CursorLine',
      strict_spacing = true,
    },
  },
  {
    'mawkler/modicator.nvim',
    config = function()
      require('modicator').setup({
        show_warnings = false,
      })
      local marks_fix_group = vim.api.nvim_create_augroup('marks-fix-hl', {})
      vim.api.nvim_create_autocmd({ 'VimEnter' }, {
        group = marks_fix_group,
        callback = function()
          vim.api.nvim_set_hl(0, 'MarkSignNumHL', {})
        end,
      })
    end,
  },
  { -- Unobtrusive max-length highlight
    'Bekaboo/deadcolumn.nvim',
    event = 'BufEnter',
    opts = {
      warning = {
        hlgroup = {
          'Warning',
          'background',
        },
      },
    },
  },
  { -- Hex color preview
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
}
