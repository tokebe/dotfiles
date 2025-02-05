return {
  -- { -- Doesn't really work that well, and causes lots of messages
  --   'kosayoda/nvim-lightbulb',
  --   config = function()
  --     require('nvim-lightbulb').setup({
  --       sign = {
  --         enabled = false,
  --       },
  --       status_text = {
  --         enabled = true,
  --         text = '󱉵',
  --         text_unavilable = '',
  --       },
  --       -- autocmd = {
  --       --   enabled = true,
  --       -- },
  --     })
  --   end,
  -- },
  {
    'folke/noice.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    version = '4.3.1',
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
        lsp = {
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
          },
        },
        -- routes = {
        --   {
        --     view = 'popup',
        --     filter = { cmdline = true, min_height = 3 },
        --   },
        --   {
        --     view = 'split',
        --     filter = { error = true, min_height = 3 },
        --   },
        -- },
        -- messages = {
        --   view_search = false,
        -- },
        -- views = {
        --   mini = {
        --     timeout = 3000,
        --   },
        --   popupmenu = {
        --     border = {
        --       style = 'none',
        --     },
        --   },
        --   popup = {
        --     border = {
        --       style = 'none',
        --     },
        --   },
        -- },
      })
      vim.keymap.set('n', '<Leader>oH', '<CMD>NoiceHistory<CR>', { desc = 'Open output history' })
    end,
  },
  {
    'folke/edgy.nvim',
    event = 'VeryLazy',
    opts = {
      animate = {
        enabled = false,
      },
      bottom = {
        {
          ft = 'toggleterm',
          title = 'Terminal',
          size = { height = 0.4 },
          -- exclude floating windows
          filter = function(buf, win)
            return vim.api.nvim_win_get_config(win).relative == ''
          end,
        },
        'Trouble',
        {
          ft = 'dap-repl',
          title = 'REPL',
          size = { height = 0.3 },
        },
        {
          ft = 'dapui_console',
          title = 'Console',
          size = { height = 0.3 },
        },
        {
          ft = 'help',
          size = { height = 0.3 },
          -- only show help buffers
          filter = function(buf)
            return vim.bo[buf].buftype == 'help'
          end,
        },
        {
          ft = 'man',
          size = { height = 0.3 },
          -- only show man buffers
          filter = function(buf)
            return vim.bo[buf].buftype == 'nofile'
          end,
        },
        {
          ft = 'qf',
        },
      },
      right = {
        {
          title = 'Neo-Tree',
          ft = 'neo-tree',
          size = { width = 36 },
        },
        -- {
        --   title = 'Grug',
        --   ft = 'grug-far',
        --   size = { width = 88 },
        -- },
        {
          ft = 'OverseerList',
          title = 'Task List',
          size = { width = 50 },
        },
        {
          ft = 'dapui_scopes',
          title = 'Scopes',
          size = { width = 80, height = 0.40 },
        },
        {
          ft = 'dapui_breakpoints',
          title = 'Breakpoints',
          size = { width = 50, height = 0.1 },
        },
        {
          ft = 'dapui_watches',
          title = 'Watches',
          size = { width = 50, height = 0.15 },
        },
        {
          ft = 'dapui_stacks',
          title = 'Stacks',
          size = { width = 50, height = 0.35 },
        },
      },
      left = {},
    },
  },
  {
    'haringsrob/nvim_context_vt',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('nvim_context_vt').setup({
        -- prefix = '󱦵',
        prefix = '󱞿 ',
        min_rows = 7,
        disable_ft = require('config.filetype_excludes'),
      })
    end,
  },
  {
    'OXY2DEV/helpview.nvim',
    lazy = false,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
}
