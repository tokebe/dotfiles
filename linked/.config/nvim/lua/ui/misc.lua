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
    version = '4',
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
        views = {
          mini = {
            timeout = 4000,
          },
        },
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
        {
          ft = 'OverseerOutput',
          title = 'Task Output',
          size = { height = 0.2 },
        },
        'Trouble',
        {
          ft = 'dap-view',
          title = false,
          size = { height = 0.35 },
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
        {
          title = 'Undo Tree',
          ft = 'undotree',
          size = { width = 0.4 },
        },
        {
          title = 'Diff',
          ft = 'diff',
          size = { width = 0.4 },
        },
        {
          title = 'Grug',
          ft = 'grug-far',
          size = { width = 88 },
        },
        {
          ft = 'OverseerList',
          title = 'Task List',
          size = { width = 36 },
        },
        {
          title = 'Tests',
          ft = 'neotest-summary',
          size = { width = 36 },
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
        priority = 500,
        disable_ft = require('config.filetype_excludes'),
      })
    end,
  },
  {
    'OXY2DEV/helpview.nvim',
    lazy = false,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  {
    'nvzone/menu',
    dependencies = { 'nvzone/volt', 'nvzone/minty' },
    config = function()
      -- Add some defaults
      local default = require('menus.default')
      table.insert(default, 5, {
        name = '󰙨  Test Actions',
        hl = 'Exblue',
        items = {
          {
            rtxt = '<Leader>Tr',
            cmd = function()
              require('neotest').run.run()
            end,
            name = 'Run nearest test',
          },
          {
            rtxt = '<Leader>TR',
            cmd = function()
              require('neotest').run.run(vim.fn.expand('%'))
            end,
            name = 'Run all tests in file',
          },
          { name = 'separator' },
          {
            rtxt = '<Leader>Tl',
            cmd = function()
              require('neotest').run.run_last()
            end,
            name = 'Re-run last test',
          },
          {
            rtxt = '<Leader>TL',
            cmd = function()
              require('neotest').run.run_last({ strategy = 'dap' })
            end,
            name = 'Debug last test',
          },
          { name = 'separator' },
          {
            rtxt = '<Leader>Td',
            cmd = function()
              require('neotest').run.run({ strategy = 'dap' })
            end,
            name = 'Debug nearest test',
          },
          {
            rtxt = '<Leader>TD',
            cmd = function()
              require('neotest').run.run({ vim.fn.expand('%'), strategy = 'dap' })
            end,
            name = 'Debug all tests in file',
          },
          { name = 'separator' },
          {
            rtxt = '<Leader>Ts',
            cmd = function()
              require('neotest').run.stop(vim.fn.expand('%'))
            end,
            name = 'Stop all active tests in file',
          },
          { name = 'separator' },
          {
            rtxt = '<Leader>Tt',
            cmd = function()
              require('neotest').summary.toggle()
            end,
            name = 'Toggle Tests panel',
          },
          {
            rtxt = '<Leader>To',
            cmd = function()
              require('neotest').output_panel.toggle()
            end,
            name = 'Toggle test output panel',
          },
        },
      })

      table.insert(default, 6, {
        name = '  Breakpoint Actions',
        hl = 'Exblue',
        items = {
          {
            name = 'Toggle breakpoint',
            cmd = 'PBToggleBreakpoint',
            rtxt = 'b',
          },
          {
            name = 'Set conditional breakpoint',
            cmd = 'PBSetConditionalBreakpoint',
            rtxt = 'c',
          },
          {
            name = 'Set logpoint',
            cmd = 'PBSetLogpoint',
            rtxt = 'l',
          },
          {
            name = 'Clear Breakpoints',
            cmd = 'PBClearAllBreakpoints',
            rtxt = 'd',
          },
        },
      })

      local handle_menu = function(mouse)
        require('menu.utils').delete_old_menus()
        vim.cmd('aunmenu PopUp') -- prevent builtin right mouse PopUp

        vim.cmd.exec('"normal! \\<RightMouse>"')

        -- clicked buf
        local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
        local options = vim.bo[buf].ft == 'NvimTree' and 'nvimtree' or 'default'

        require('menu').open(options, { mouse = mouse })
      end

      vim.keymap.set('n', '<RightMouse>', function()
        handle_menu(true)
      end)
      vim.keymap.set('n', '<C-t>', function()
        handle_menu(false)
      end, { desc = 'Open context menu' })
    end,
  },
  {
    'nvzone/showkeys',
    cmd = 'ShowkeysToggle',
    opts = {
      maxkeys = 5,
    },
  },
}
