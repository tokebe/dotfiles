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
        -- autocmd = {
        --   enabled = true,
        -- },
      })
    end,
  },
  {
    'nvim-zh/colorful-winsep.nvim',
    event = { 'WinNew' },
    config = function()
      require('colorful-winsep').setup({
        -- symbols = { '═', '║', '╔ ', '╗', '╚', '╝' },
        -- no_exec_files = require('config.filetype_excludes'),
        no_exec_files = {
          'telescopePrompt',
          'TelescopeResults',
          'DressingSelect',
          'mason',
          'null-ls-info',
          'lazy',
          'lspinfo',
          'WhichKey',
          'dashboard',
          'dashboardpreview',
        },
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
  -- {
  --   'petertriho/nvim-scrollbar',
  --   config = function()
  --     require('scrollbar').setup({
  --       excluded_filetypes = require('config.filetype_excludes'),
  --       marks = {
  --         Cursor = {
  --           text = '',
  --         },
  --       },
  --       handle = {
  --         blend = 70,
  --         highlight = 'TabLineSel',
  --       },
  --       handlers = {
  --         gitsigns = true,
  --         search = true,
  --       },
  --       excluded_filetypes = require('config.filetype_excludes'),
  --     })
  --   end,
  -- },
  {
    'lewis6991/satellite.nvim',
    config = function()
      require('satellite').setup({})
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
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    config = function()
      -- Set up some requirements for UFO (folding)
      vim.o.foldcolumn = '1' -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end,
      })
    end,
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
      vim.api.nvim_create_autocmd({ 'FileType' }, {
        callback = function()
          local filetype_excludes = require('config.filetype_excludes')
          for i, value in ipairs(filetype_excludes) do
            if vim.bo.filetype == value then
              return
            end
          end
          require('statuscol').setup({
            relculright = true,
            ft_ignore = require('config.filetype_excludes'),
            segments = {
              {
                sign = { name = { 'Diagnostic', 'todo.*' }, maxwidth = 2, colwidth = 2, auto = false },
                click = 'v:lua.ScSa',
              },
              {
                sign = { name = { 'Breakpoint' }, maxwidth = 2, colwidth = 2, auto = true },
                click = 'v:lua.ScSa',
              },
              { text = { builtin.lnumfunc }, click = 'v:lua.ScLa' },
              {
                sign = { name = { '.*' }, maxwidth = 1, colwidth = 1, auto = false },
                click = 'v:lua.ScSa',
              },
              { text = { builtin.foldfunc, ' ' }, click = 'v:lua.ScFa' },
            },
          })
        end,
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
        cmdline = {
          view = 'cmdline',
          format = {
            cmdline = { pattern = '^:', icon = '', lang = 'vim' },
            search_down = { kind = 'search', pattern = '^/', icon = ' ', lang = 'regex' },
            search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex' },
            filter = { pattern = '^:%s*!', icon = '$', lang = 'bash' },
            lua = { pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' }, icon = '', lang = 'lua' },
            help = { pattern = '^:%s*he?l?p?%s+', icon = '󰋖 ' },
          },
        },
        routes = {
          {
            view = 'popup',
            filter = { cmdline = true, min_height = 3 },
          },
          {
            view = 'split',
            filter = { error = true, min_height = 3 },
          },
        },
        messages = {
          view_search = false,
        },
        views = {
          mini = {
            timeout = 3000,
          },
          popupmenu = {
            border = {
              style = 'none',
            },
          },
          popup = {
            border = {
              style = 'none',
            },
          },
        },
      })
    end,
  },
  {
    'folke/edgy.nvim',
    event = 'VeryLazy',
    opts = {
      bottom = {
        {
          ft = 'toggleterm',
          size = { height = 0.3 },
          -- exclude floating windows
          filter = function(buf, win)
            return vim.api.nvim_win_get_config(win).relative == ''
          end,
        },
        'Trouble',
        {
          ft = 'help',
          size = { height = 0.3 },
          -- only show help buffers
          filter = function(buf)
            return vim.bo[buf].buftype == 'help'
          end,
        },
      },
      right = {
        {
          ft = 'spectre_panel',
          size = { width = 80 },
        },
      },
    },
  },
  {
    'jinh0/eyeliner.nvim',
    config = function()
      require('eyeliner').setup({
        highlight_on_key = true,
      })
    end,
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    config = function()
      vim.g.neo_tree_remove_legacy_commands = 1

      -- Diagnostic signs
      vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
      vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
      vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
      vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })

      require('neo-tree').setup({
        add_blank_line_at_top = true,
        popup_border_style = 'NC',
        sources = {
          'filesystem',
          'buffers',
          'git_status',
          'document_symbols',
        },
        source_selector = {
          winbar = true,
        },
        window = {
          position = 'right',
        },
        filesystem = {
          filtered_items = {
            visible = true,
          },
        },
        default_component_configs = {
          indent = {
            -- with_expanders = true,
          },
          modified = {
            symbol = '󰏫 ',
          },
          name = {
            highlight_opened_files = true,
          },
          git_status = {
            symbols = {
              -- Change type
              added = ' ',
              deleted = ' ',
              modified = '',
              renamed = '',
              -- Status type
              untracked = '',
              ignored = ' ',
              unstaged = '󰄱 ',
              staged = '󰄵 ',
              conflict = '󰃸 ',
            },
          },
        },
      })
    end,
  },
}
