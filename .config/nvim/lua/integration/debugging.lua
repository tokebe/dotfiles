-- TODO: redo controls from scratch
return {
  {
    'mfussenegger/nvim-dap',
    dependencies = { 'folke/which-key.nvim' },
    event = { 'LspAttach' },
    config = function()
      local dap = require('dap')
      dap.defaults.fallback.external_terminal = {
        command = 'tmux',
        args = { 'split-pane', '-l', '30%' },
      }
      -- dap.defaults.fallback.force_external_terminal = true
    end,
  },
  {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'mfussenegger/nvim-dap',
    },
    config = function()
      require('mason-nvim-dap').setup({
        automatic_installation = true,
        ensure_installed = require('config.sources').dap,
      })
      local node_config = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          args = {
            -- require('mason-registry').get_package('js-debug-adapter'):get_install_path()
            vim.fn.expand('$MASON/bin/js-debug-adapter') .. '/js-debug/src/dapDebugServer.js',
            '${port}',
          },
        },
      }
      require('dap').adapters['pwa-node'] = node_config
    end,
  },
  {
    'igorlfs/nvim-dap-view',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/nvim-nio',
    },
    config = function()
      local dapview = require('dap-view')
      dapview.setup({
        auto_toggle = true,
        winbar = {
          default_section = 'scopes',
          controls = {
            enabled = true,
          },
        },
        windows = {
          height = 0.35,
        },
      })

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

      vim.fn.sign_define('DapStopped', { text = ' ', texthl = 'DapStopped', numhl = 'DapStopped' })
    end,
  },
  {
    'stevearc/overseer.nvim',
    dependencies = {
      'mfussenegger/nvim-dap',
      'akinsho/toggleterm.nvim',
      'nvimtools/hydra.nvim',
    },
    init = function() -- Had to change 'config' -> 'init' to even be called?
      local dap = require('dap')
      local overseer = require('overseer')
      overseer.setup({
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
      overseer.patch_dap(true)

      -- local Hydra = require('hydra')

      -- TODO: re-implement using nvim-libmodal?

      -- Hydra({
      --   name = 'Debugging',
      --   hint = [[
      -- _d_: Start a Debugging Session   _c_: Continue                      _C_: Continue to Cursor
      -- _p_: Pause                       _s_: Stop                          _r_: Restart
      -- _H_: Step Out                    _J_: Step Over                     _L_: Step Into
      -- _f_: Find Breakpoints            _t_: Run Task...                   _u_: Toggle UI
      --                                ^^_q_: Exit Debug Mode
      --         ]],
      --   mode = { 'n' },
      --   body = '<Leader>D',
      --   config = {
      --     color = 'pink',
      --     buffer = false,
      --     invoke_on_body = true,
      --     description = 'Debugging Mode',
      --     hint = {
      --       type = 'window',
      --       offset = 1,
      --       position = 'bottom-left',
      --       float_opts = {
      --         border = 'shadow',
      --       },
      --     },
      --   },
      --   heads = {
      --     {
      --       'q',
      --       nil,
      --       {
      --         desc = 'Exit',
      --         private = true,
      --         exit = true,
      --       },
      --     },
      --     {
      --       'd',
      --       function()
      --         if vim.fn.filereadable('.vscode/launch.json') then
      --           require('dap.ext.vscode').json_decode = require('overseer.json').decode
      --           require('dap.ext.vscode').load_launchjs(nil, {
      --             ['pwa-node'] = { 'javascript', 'typescript' },
      --           })
      --         end
      --         require('fzf-lua').dap_configurations({
      --           winopts = {
      --             height = 0.3,
      --             width = 0.4,
      --             row = 0.9,
      --             col = 0.9,
      --             relative = 'editor',
      --           },
      --         })
      --       end,
      --       {
      --         desc = 'Start a debugging session',
      --         private = true,
      --         exit = true,
      --         nowait = true,
      --       },
      --     },
      --   },
      -- })

      local wk = require('which-key')
      vim.keymap.set('n', '<Leader>D', function()
        wk.show({ loop = true, keys = '<Leader>_' })
      end, { desc = 'Debugging...' })

      vim.keymap.set('n', '<Leader>_d', function()
        -- Overseer compat
        if vim.fn.filereadable('.vscode/launch.json') then
          require('dap.ext.vscode').json_decode = require('overseer.json').decode
        end
        -- TODO: this fails to make DAP load its configs
        -- But just a normal :DapContinue works?
        -- so maybe figure out how to configure that, idk
        require('fzf-lua').dap_configurations({
          winopts = {
            height = 0.3,
            width = 0.4,
            row = 0.9,
            col = 0.9,
            relative = 'editor',
          },
        })
        wk.show({ loop = true, keys = '<Leader>_' })
      end, { desc = 'Start a debugging session' })
      vim.keymap.set('n', '<Leader>_p', dap.pause, { desc = 'Pause' })
      vim.keymap.set('n', '<Leader>_c', dap.continue, { desc = 'Continue' })
      vim.keymap.set('n', '<Leader>_C', dap.run_to_cursor, { desc = 'Continue to cursor' })
      vim.keymap.set('n', '<Leader>_s', dap.terminate, { desc = 'Stop' })
      vim.keymap.set('n', '<Leader>_r', dap.restart, { desc = 'Restart' })
      vim.keymap.set('n', '<Leader>_u', require('dap-view').toggle, { desc = 'Toggle Debug UI' })
      vim.keymap.set('n', '<Leader>_f', dap.list_breakpoints, { desc = 'Find breakpoints' })
      vim.keymap.set('n', '<Leader>_J', dap.step_over, { desc = 'Step over' })
      vim.keymap.set('n', '<Leader>_L', dap.step_into, { desc = 'Step into' })
      vim.keymap.set('n', '<Leader>_H', dap.step_out, { desc = 'Step out' })
      vim.keymap.set('n', '<Leader>_t', '<CMD>OverseerRun<CR>', { desc = 'Run task...' })

      vim.keymap.set('n', '<Leader>tr', '<CMD>OverseerRun<CR>', { desc = 'Run task...' })
      vim.keymap.set('n', '<Leader>tv', '<CMD>OverseerToggle<CR>', { desc = 'Toggle task view' })
      vim.keymap.set('n', '<Leader>bb', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
      vim.keymap.set('n', '<Leader>bc', function()
        vim.ui.input({ prompt = 'Breakpoint condition: ' }, function(input)
          if input ~= nil then
            dap.set_breakpoint(input)
          end
        end)
      end, { desc = 'Set conditional breakpoint' })
      vim.keymap.set('n', '<Leader>bl', function()
        vim.ui.input({ prompt = 'Logpoint message: ' }, function(input)
          if input ~= nil then
            dap.set_breakpoint({ nil, nil, input })
          end
        end)
      end, { desc = 'Set Logpoint' })
      -- local continue = function(opts)
      --   if vim.fn.filereadable('.vscode/launch.json') then
      --     require('dap.ext.vscode').json_decode = require('overseer.json').decode
      --     require('dap.ext.vscode').load_launchjs(nil, {
      --       ['pwa-node'] = { 'javascript', 'typescript' },
      --     })
      --   end
      --   require('dap').continue(opts)
      -- end
      -- vim.keymap.set('n', '<Leader>Dd', function()
      --   if vim.fn.filereadable('.vscode/launch.json') then
      --     require('dap.ext.vscode').json_decode = require('overseer.json').decode
      --     require('dap.ext.vscode').load_launchjs(nil, {
      --       ['pwa-node'] = { 'javascript', 'typescript' },
      --     })
      --   end
      --   require('fzf-lua').dap_configurations({
      --     winopts = {
      --       height = 0.3,
      --       width = 0.4,
      --       row = 0.9,
      --       col = 0.9,
      --       relative = 'editor',
      --     },
      --   })
      -- end, { desc = 'Start a debugging session' })
      -- vim.keymap.set('n', '<Leader>Dc', continue, { desc = 'Continue' })
      -- vim.keymap.set('n', '<Leader>Dp', require('dap').pause, { desc = 'Pause' })
      -- vim.keymap.set('n', '<Leader>DC', require('dap').run_to_cursor, { desc = 'Continue to cursor' })
      -- vim.keymap.set('n', '<Leader>Ds', require('dap').terminate, { desc = 'Stop' })
      -- vim.keymap.set('n', '<Leader>Dr', require('dap').restart, { desc = 'Restart' })
      -- vim.keymap.set('n', '<Leader>bb', require('dap').toggle_breakpoint, { desc = 'Toggle breakpoint' })
      -- vim.keymap.set('n', '<Leader>bc', function()
      --   vim.ui.input({ prompt = 'Breakpoint condition: ' }, function(input)
      --     if input ~= nil then
      --       require('dap').set_breakpoint(input)
      --     end
      --   end)
      -- end, { desc = 'Set conditional breakpoint' })
      -- vim.keymap.set('n', '<Leader>bl', function()
      --   vim.ui.input({ prompt = 'Logpoint message: ' }, function(input)
      --     if input ~= nil then
      --       require('dap').set_breakpoint({ nil, nil, input })
      --     end
      --   end)
      -- end, { desc = 'Set Logpoint' })
      -- vim.keymap.set('n', '<Leader>B', require('dap').list_breakpoints, { desc = 'List breakpoints' })
      -- vim.keymap.set('n', '<Leader>Dv', require('dap').step_over, { desc = 'Step over' })
      -- vim.keymap.set('n', '<Leader>Di', require('dap').step_into, { desc = 'Step into' })
      -- vim.keymap.set('n', '<Leader>Do', require('dap').step_out, { desc = 'Step out' })
      -- vim.keymap.set('n', '<Leader>tr', '<CMD>OverseerRun<CR>', { desc = 'Run task...' })
      -- vim.keymap.set('n', '<Leader>tv', '<CMD>OverseerToggle<CR>', { desc = 'Toggle task view' })
    end,
  },
  -- {
  --   'theHamsta/nvim-dap-virtual-text',
  --   dependencies = { 'mfussenegger/nvim-dap', 'nvim-treesitter/nvim-treesitter' },
  --   event = { 'LspAttach' },
  --   config = function()
  --     require('nvim-dap-virtual-text').setup({
  --       all_references = true,
  --       -- commented = true,
  --     })
  --   end,
  -- },
  {
    'LiadOz/nvim-dap-repl-highlights', -- DAP highlighting support
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'mfussenegger/nvim-dap',
    },
    event = { 'LspAttach' },
    config = function()
      require('nvim-dap-repl-highlights').setup()
    end,
  },
}
