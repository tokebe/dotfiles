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
          text_unavilable = '',
        },
        autocmd = {
          enabled = true,
        },
      })
    end,
  },
  {
    'nvim-zh/colorful-winsep.nvim',
    event = { 'WinNew' },
    config = function()
      require('colorful-winsep').setup({
        -- symbols = { '═', '║', '╔ ', '╗', '╚', '╝' },
        no_exec_files = require('config.filetype_excludes'),
      })
    end,
  },
  {
    'prochri/telescope-all-recent.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'kkharji/sqlite.lua',
    },
    config = function()
      require('telescope-all-recent').setup({
        vim_ui_select = {
          kinds = {
            overseer_template = {
              use_cwd = true,
              prompt = 'Task template',
              -- include the prompt in the picker name
              -- helps differentiate between same picker kinds with different prompts
              name_include_prompt = true,
            },
          },
          -- used as fallback if no kind configuration is available
          prompts = {
            ['Load session'] = {
              use_cwd = false,
            },
          },
        },
      })
    end,
  },
  -- { -- Doesn't really work in this setup yet. Come back to it.
  --   'smjonas/live-command.nvim',
  --   config = function()
  --     require('live-command').setup({
  --       commands = {
  --         Norm = { cmd = 'norm' },
  --         G = { cmd = 'g' },
  --         D = { cmd = 'd' },
  --       },
  --     })
  --   end,
  -- },
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
  {
    'folke/todo-comments.nvim',
    requires = 'nvim-lua/plenary.nvim',
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
    'bennypowers/nvim-regexplainer',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('regexplainer').setup({
        auto = true,
      })
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
    'kdheepak/tabline.nvim',
    config = function()
      require('tabline').setup({
        enable = true,
        options = {
          modified_icon = '',
          modified_italic = true,
          section_separators = { '', '' },
          component_separators = { '╱', '╱' },
          show_filename_only = true,
          show_tabs_always = true,
        },
      })
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '│' },
        change = { text = '│' },
        delete = { text = '│' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  {
    'luukvbaal/statuscol.nvim',
    -- commit = 'd9ee308',
    config = function()
      local builtin = require('statuscol.builtin')

      vim.opt.fillchars = {
        foldopen = '',
        foldclose = '',
        foldsep = ' ',
        eob = ' ',
      }

      require('statuscol').setup({
        relculright = true,
        segments = {
          {
            sign = { name = { 'Diagnostic', 'todo.*' }, maxwidth = 2, colwidth = 2, auto = false },
            click = 'v:lua.ScSa',
          },
          {
            sign = { name = { 'Breakpoint' }, maxwidth = 1, colwidth = 1, auto = true },
            click = 'v:lua.ScSa',
          },
          { text = { builtin.lnumfunc }, click = 'v:lua.ScLa' },
          {
            sign = { name = { '.*' }, maxwidth = 1, colwidth = 1, auto = true },
            click = 'v:lua.ScSa',
          },
          { text = { builtin.foldfunc, ' ' }, click = 'v:lua.ScFa' },
        },
      })
    end,
  },
  {
    'folke/noice.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('noice').setup({
        views = {
          mini = {
            timeout = 5000,
          },
        },
        cmdline = {
          view = 'cmdline',
          format = {
            cmdline = { pattern = '^:', icon = '', lang = 'vim' },
            search_down = { kind = 'search', pattern = '^/', icon = '󰩊 ', lang = 'regex' },
            search_up = { kind = 'search', pattern = '^%?', icon = '󰩊 ', lang = 'regex' },
            filter = { pattern = '^:%s*!', icon = '$', lang = 'bash' },
            lua = { pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' }, icon = '', lang = 'lua' },
            help = { pattern = '^:%s*he?l?p?%s+', icon = '󰋖 ' },
          },
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
}
