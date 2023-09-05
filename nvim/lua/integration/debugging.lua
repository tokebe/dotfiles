return {
  { 'mfussenegger/nvim-dap' },
  {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = { 'williamboman/mason-lspconfig.nvim', 'mfussenegger/nvim-dap', 'VonHeikemen/lsp-zero.nvim' },
    event = { 'LspAttach' },
    config = function()
      require('mason-nvim-dap').setup({
        automatic_installation = true,
        ensure_installed = require('config.sources').dap,
      })
      require('dap').adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          args = {
            require('mason-registry').get_package('js-debug-adapter'):get_install_path()
            .. '/js-debug/src/dapDebugServer.js',
            '${port}',
          },
        },
      }
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-treesitter/nvim-treesitter' },
    event = { 'LspAttach' },
    config = function()
      local dap, dapui = require('dap'), require('dapui')
      -- Open DAP UI when DAP is initialized
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      -- dap.listeners.before.event_terminated['dapui_config'] = function()
      --   dapui.close()
      -- end
      -- dap.listeners.before.event_exited['dapui_config'] = function()
      --   dapui.close()
      -- end

      -- Create highlights for the types of breakpoints
      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = '*',
        -- group = 'UserDefLoadOnce',
        desc = 'Prevent coloscheme clearing self-defined DAP icon colors',
        callback = function()
          vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '#31353f' })
          vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939', bg = '#31353f' })
          vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bg = '#31353f' })
        end,
      })

      vim.fn.sign_define('DapBreakpoint', { text = ' ', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
      vim.fn.sign_define(
        'DapBreakpointCondition',
        { text = '󱄶 ', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' }
      )
      vim.fn.sign_define('DapBreakpointRejected', { text = ' ', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
      vim.fn.sign_define('DapLogPoint', { text = '󰚢 ', texthl = 'DapLogPoint', numhl = 'DapLogPoint' })
      dapui.setup({
        controls = {
          element = 'repl',
          enabled = true,
          icons = {
            disconnect = '',
            pause = '',
            play = '',
            run_last = '',
            step_back = '',
            step_into = '',
            step_out = '',
            step_over = '',
            terminate = '',
          },
        },
        element_mappings = {},
        expand_lines = true,
        floating = {
          border = 'none',
          mappings = {
            close = { 'q', '<Esc>' },
          },
        },
        force_buffers = true,
        icons = {
          collapsed = '',
          current_frame = '',
          expanded = '',
        },
        layouts = {
          {
            elements = {
              {
                id = 'scopes',
                size = 0.25,
              },
              {
                id = 'breakpoints',
                size = 0.25,
              },
              {
                id = 'stacks',
                size = 0.25,
              },
              {
                id = 'watches',
                size = 0.25,
              },
            },
            position = 'right',
            size = 40,
          },
          {
            elements = {
              {
                id = 'repl',
                size = 0.5,
              },
              {
                id = 'console',
                size = 0.5,
              },
            },
            position = 'bottom',
            size = 10,
          },
        },
        -- mappings = {
        --   edit = 'e',
        --   expand = { '<CR>', '<2-LeftMouse>' },
        --   open = 'o',
        --   remove = 'd',
        --   repl = 'r',
        --   toggle = 't',
        -- },
        render = {
          indent = 1,
          max_value_lines = 100,
        },
      })
      vim.fn.sign_define('DapStopped', { text = ' ', texthl = 'DapStopped', numhl = 'DapStopped' })
    end,
  },
  {
    'stevearc/overseer.nvim',
    dependencies = {
      'mfussenegger/nvim-dap',
      'akinsho/toggleterm.nvim',
      'rcarriga/nvim-dap-ui',
    },
    event = 'LspAttach',
    config = function()
      local util = require('util')
      require('overseer').setup({
        strategy = {
          'toggleterm',
          open_on_start = false,
          use_shell = true,
          auto_scroll = true,
        },
        task_list = {
          bindings = {
            ['<C-h>'] = false,
            ['<C-l>'] = false,
            ['<C-j>'] = false,
            ['<C-k>'] = false,
          },
        },
      })
      local continue = function(opts)
        if vim.fn.filereadable('.vscode/launch.json') then
          require('dap.ext.vscode').json_decode = require('overseer.json').decode
          require('dap.ext.vscode').load_launchjs(nil, {
            ['pwa-node'] = { 'javascript', 'typescript' },
          })
        end
        require('dap').continue(opts)
      end
      util.keymap('n', '<Leader>dd', function()
        continue({ new = true })
      end, { desc = 'Start a debugging session' })
      util.keymap('n', '<Leader>dc', continue, { desc = 'Continue' })
      util.keymap('n', '<Leader>dp', require('dap').pause, { desc = 'Continue' })
      util.keymap('n', '<Leader>dC', require('dap').run_to_cursor, { desc = 'Continue to cursor' })
      util.keymap('n', '<Leader>ds', require('dap').close, { desc = 'Stop' })
      util.keymap('n', '<Leader>dr', require('dap').restart, { desc = 'Stop' })
      util.keymap('n', '<Leader>dt', require('dapui').toggle, { desc = 'Toggle Debug UI' })
      util.keymap('n', '<Leader>bb', require('dap').toggle_breakpoint, { desc = 'Toggle breakpoint' })
      util.keymap('n', '<Leader>bc', function()
        vim.ui.input({ prompt = 'Breakpoint condition: ' }, function(input)
          if input ~= nil then
            require('dap').set_breakpoint(input)
          end
        end)
      end, { desc = 'Set conditional breakpoint' })
      util.keymap('n', '<Leader>bl', function()
        vim.ui.input({ prompt = 'Logpoint message: ' }, function(input)
          if input ~= nil then
            require('dap').set_breakpoint({ nil, nil, input })
          end
        end)
      end, { desc = 'Set Logpoint' })
      util.keymap('n', '<Leader>B', require('dap').list_breakpoints, { desc = 'List breakpoints' })
      util.keymap('n', '<Leader>dv', require('dap').step_over, { desc = 'Step over' })
      util.keymap('n', '<Leader>di', require('dap').step_into, { desc = 'Step into' })
      util.keymap('n', '<Leader>do', require('dap').step_out, { desc = 'Step out' })
      util.keymap('n', '<Leader>tr', '<CMD>OverseerRun<CR>', { desc = 'Run task...' })
      util.keymap('n', '<Leader>tv', '<CMD>OverseerToggle<CR>', { desc = 'Toggle task view' })
    end,
  },
  {
    'Weissle/persistent-breakpoints.nvim',
    dependencies = { 'mfussenegger/nvim-dap' },
    event = { 'LspAttach' },
    config = function()
      require('persistent-breakpoints').setup({
        load_breakpoints_event = { 'BufReadPost' },
      })
    end,
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-treesitter/nvim-treesitter' },
    event = { 'LspAttach' },
    config = function()
      require('nvim-dap-virtual-text').setup({
        all_references = true,
        -- commented = true,
      })
    end,
  },
  {
    'LiadOz/nvim-dap-repl-highlights', -- DAP highlighting support
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'mfussenegger/nvim-dap',
    },
    config = function()
      require('nvim-dap-repl-highlights').setup()
    end,
  },
  -- {
  --   'mxsdev/nvim-dap-vscode-js',
  --   dependencies = { 'mfussenegger/nvim-dap' },
  --   event = { 'LspAttach' },
  --   config = function()
  --     -- require('dap-vscode-js').setup({
  --     --   debugger_path = vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter',
  --     --   adapters = { 'node', 'pwa-node', 'chrome', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
  --     -- })
  --     -- for _, language in ipairs({ 'typescript', 'javascript' }) do
  --     --   require('dap').configurations[language] = {
  --     --     {
  --     --       type = 'pwa-node',
  --     --       request = 'launch',
  --     --       name = 'Launch file',
  --     --       program = '${file}',
  --     --       cwd = '${workspaceFolder}',
  --     --     },
  --     --   }
  --     -- end
  --   end,
  -- },
}
