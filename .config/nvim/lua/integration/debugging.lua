-- Create highlights for the types of breakpoints
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  -- group = 'UserDefLoadOnce',
  desc = 'Prevent coloscheme clearing self-defined DAP icon colors',
  callback = function()
    vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#3e8fb0' })
    vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#eb6f92' })
    vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#f6c177' })
  end,
})

vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointCondition', { text = '󱄶 ', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointRejected', { text = ' ', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapLogPoint', { text = '󰚢 ', texthl = 'DapLogPoint', numhl = 'DapLogPoint' })

vim.fn.sign_define('DapStopped', { text = ' ', texthl = 'DapStopped', numhl = 'DapStopped' })

return {
  {
    'igorlfs/nvim-dap-view',
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/nvim-nio',
      'mfussenegger/nvim-dap',
      { 'jay-babu/mason-nvim-dap.nvim', dependencies = { 'williamboman/mason.nvim' } },
      'Weissle/persistent-breakpoints.nvim',
      { 'stevearc/overseer.nvim' },
    },
    config = function()
      -- FIX: ftmemo creates errors on opening repl, figure out how to suppress
      local dap = require('dap')
      local uv = vim.uv or vim.loop

      -- Set external terminal to use tmux
      dap.defaults.fallback.external_terminal = {
        command = 'tmux',
        args = { 'split-pane', '-l', '30%' },
      }

      -- Fix some weirdness with dap focus switch
      dap.defaults.fallback.switchbuf = 'usevisible,usetab,newtab'

      -- Open dap-view whenever a debug session starts
      dap.listeners.before.launch.dap_view = function()
        require('dap-view').open()
      end

      -- TODO: Set up keybinds for special commands
      -- Persistent breakpoints. Have to use its commands for them to persist.
      require('persistent-breakpoints').setup({
        load_breakpoints_event = { 'BufReadPost' },
      })

      -- Should bridge *most* mason-installed adapters to nvim-dap
      require('mason-nvim-dap').setup({
        ensure_installed = require('config.sources').dap,
        handlers = {},
        automatic_installation = true,
      })

      -- VSCode introduced a stupid change where debug configs
      -- need to use type: `debugpy` instead of `python`
      -- So we need a custom debugpy adapter to point to our python adapter (sigh)
      -- Additionally, we need to inject the .venv, and some other setup
      -- Big thanks to https://codeberg.org/mfussenegger/nvim-dap-python
      -- For most of the config pattern
      dap.adapters.debugpy = {
        type = 'executable',
        command = vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python',
        args = {
          '-m',
          'debugpy.adapter',
        },
        enrich_config = function(config, on_config)
          -- Add the python venv to the config
          local venv_path = os.getenv('VIRTUAL_ENV')
          if venv_path then
            config.pythonPath = venv_path .. '/bin/python'
          end
          for _, folder in ipairs({ 'venv', '.venv', 'env', '.env' }) do
            local path = vim.fn.getcwd() .. '/' .. folder
            local stat = uv.fs_stat(path)
            if stat and stat.type == 'directory' then
              config.pythonPath = path .. '/bin/python'
            end
          end

          -- Force config to use externalTerminal
          config.console = 'externalTerminal'
          on_config(config)
        end,
      }

      -- Old node debug config, probably needs work
      -- dap.adapters['pwa-node'] = {
      --   type = 'server',
      --   host = 'localhost',
      --   port = '${port}',
      --   executable = {
      --     command = 'node',
      --     args = {
      --       -- require('mason-registry').get_package('js-debug-adapter'):get_install_path()
      --       vim.fn.expand('$MASON/bin/js-debug-adapter') .. '/js-debug/src/dapDebugServer.js',
      --       '${port}',
      --     },
      --   },
      -- }

      -- Override default python launch config so it uses the above debugpy adapter
      dap.configurations.python = {
        {
          type = 'debugpy',
          request = 'launch',
          name = 'Launch current file',
          program = '${file}',
        },
      }

      -- Provides a decent UI, might switch back to dap-ui for toggleable breakpoints
      local dapview = require('dap-view')
      dapview.setup({
        auto_toggle = false,
        winbar = {
          default_section = 'sessions',
          sections = { 'sessions', 'threads', 'watches', 'exceptions', 'breakpoints', 'scopes', 'repl', 'console' },
          controls = {
            enabled = true,
          },
        },
        windows = {
          size = 0.35,
          terminal = {
            size = 0.5,
          },
        },
      })

      vim.keymap.set(
        'n',
        '<Leader>bb',
        require('persistent-breakpoints.api').toggle_breakpoint,
        { desc = 'Toggle breakpoint' }
      )
      vim.keymap.set('n', '<Leader>bc', function()
        require('persistent-breakpoints.api').set_conditional_breakpoint()
      end, { desc = 'Set conditional breakpoint' })
      vim.keymap.set('n', '<Leader>bl', function()
        require('persistent-breakpoints.api').set_log_point()
      end, { desc = 'Set Logpoint' })
      vim.keymap.set('n', '<Leader>bd', function()
        require('persistent-breakpoints.api').clear_all_breakpoints()
      end, { desc = 'Clear all breakpoints' })
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
  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-dap-virtual-text').setup({
        virt_lines = true,
      })
    end,
  },

  -- {
  --   'stevearc/overseer.nvim',
  --   dependencies = {
  --     'mfussenegger/nvim-dap',
  --     'akinsho/toggleterm.nvim',
  --     'nvimtools/hydra.nvim',
  --   },
  --   init = function() -- Had to change 'config' -> 'init' to even be called?
  --     local dap = require('dap')
  --     local overseer = require('overseer')
  --     overseer.setup({
  --       strategy = {
  --         'toggleterm',
  --         open_on_start = false,
  --         use_shell = true,
  --         auto_scroll = true,
  --       },
  --       task_list = {
  --         bindings = {
  --           ['<C-h>'] = false,
  --           ['<C-l>'] = false,
  --           ['<C-j>'] = false,
  --           ['<C-k>'] = false,
  --         },
  --       },
  --     })
  --     -- overseer.patch_dap(true)
  --
  --     -- local Hydra = require('hydra')
  --
  --     -- TODO: re-implement using nvim-libmodal?
  --
  --     -- Hydra({
  --     --   name = 'Debugging',
  --     --   hint = [[
  --     -- _d_: Start a Debugging Session   _c_: Continue                      _C_: Continue to Cursor
  --     -- _p_: Pause                       _s_: Stop                          _r_: Restart
  --     -- _H_: Step Out                    _J_: Step Over                     _L_: Step Into
  --     -- _f_: Find Breakpoints            _t_: Run Task...                   _u_: Toggle UI
  --     --                                ^^_q_: Exit Debug Mode
  --     --         ]],
  --     --   mode = { 'n' },
  --     --   body = '<Leader>D',
  --     --   config = {
  --     --     color = 'pink',
  --     --     buffer = false,
  --     --     invoke_on_body = true,
  --     --     description = 'Debugging Mode',
  --     --     hint = {
  --     --       type = 'window',
  --     --       offset = 1,
  --     --       position = 'bottom-left',
  --     --       float_opts = {
  --     --         border = 'shadow',
  --     --       },
  --     --     },
  --     --   },
  --     --   heads = {
  --     --     {
  --     --       'q',
  --     --       nil,
  --     --       {
  --     --         desc = 'Exit',
  --     --         private = true,
  --     --         exit = true,
  --     --       },
  --     --     },
  --     --     {
  --     --       'd',
  --     --       function()
  --     --         if vim.fn.filereadable('.vscode/launch.json') then
  --     --           require('dap.ext.vscode').json_decode = require('overseer.json').decode
  --     --           require('dap.ext.vscode').load_launchjs(nil, {
  --     --             ['pwa-node'] = { 'javascript', 'typescript' },
  --     --           })
  --     --         end
  --     --         require('fzf-lua').dap_configurations({
  --     --           winopts = {
  --     --             height = 0.3,
  --     --             width = 0.4,
  --     --             row = 0.9,
  --     --             col = 0.9,
  --     --             relative = 'editor',
  --     --           },
  --     --         })
  --     --       end,
  --     --       {
  --     --         desc = 'Start a debugging session',
  --     --         private = true,
  --     --         exit = true,
  --     --         nowait = true,
  --     --       },
  --     --     },
  --     --   },
  --     -- })
  --
  --     local wk = require('which-key')
  --     vim.keymap.set('n', '<Leader>D', function()
  --       wk.show({ loop = true, keys = '<Leader>_' })
  --     end, { desc = 'Debugging...' })
  --
  --     vim.keymap.set('n', '<Leader>_d', function()
  --       -- Overseer compat
  --       if vim.fn.filereadable('.vscode/launch.json') then
  --         require('dap.ext.vscode').json_decode = require('overseer.json').decode
  --       end
  --       -- TODO: this fails to make DAP load its configs
  --       -- But just a normal :DapContinue works?
  --       -- so maybe figure out how to configure that, idk
  --       require('fzf-lua').dap_configurations({
  --         winopts = {
  --           height = 0.3,
  --           width = 0.4,
  --           row = 0.9,
  --           col = 0.9,
  --           relative = 'editor',
  --         },
  --       })
  --       wk.show({ loop = true, keys = '<Leader>_' })
  --     end, { desc = 'Start a debugging session' })
  --     vim.keymap.set('n', '<Leader>_p', dap.pause, { desc = 'Pause' })
  --     vim.keymap.set('n', '<Leader>_c', dap.continue, { desc = 'Continue' })
  --     vim.keymap.set('n', '<Leader>_C', dap.run_to_cursor, { desc = 'Continue to cursor' })
  --     vim.keymap.set('n', '<Leader>_s', dap.terminate, { desc = 'Stop' })
  --     vim.keymap.set('n', '<Leader>_r', dap.restart, { desc = 'Restart' })
  --     vim.keymap.set('n', '<Leader>_u', require('dap-view').toggle, { desc = 'Toggle Debug UI' })
  --     vim.keymap.set('n', '<Leader>_f', dap.list_breakpoints, { desc = 'Find breakpoints' })
  --     vim.keymap.set('n', '<Leader>_J', dap.step_over, { desc = 'Step over' })
  --     vim.keymap.set('n', '<Leader>_L', dap.step_into, { desc = 'Step into' })
  --     vim.keymap.set('n', '<Leader>_H', dap.step_out, { desc = 'Step out' })
  --     vim.keymap.set('n', '<Leader>_t', '<CMD>OverseerRun<CR>', { desc = 'Run task...' })
  --
  --     vim.keymap.set('n', '<Leader>tr', '<CMD>OverseerRun<CR>', { desc = 'Run task...' })
  --     vim.keymap.set('n', '<Leader>tv', '<CMD>OverseerToggle<CR>', { desc = 'Toggle task view' })
  --     vim.keymap.set('n', '<Leader>bb', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
  --     vim.keymap.set('n', '<Leader>bc', function()
  --       vim.ui.input({ prompt = 'Breakpoint condition: ' }, function(input)
  --         if input ~= nil then
  --           dap.set_breakpoint(input)
  --         end
  --       end)
  --     end, { desc = 'Set conditional breakpoint' })
  --     vim.keymap.set('n', '<Leader>bl', function()
  --       vim.ui.input({ prompt = 'Logpoint message: ' }, function(input)
  --         if input ~= nil then
  --           dap.set_breakpoint({ nil, nil, input })
  --         end
  --       end)
  --     end, { desc = 'Set Logpoint' })
  --     -- local continue = function(opts)
  --     --   if vim.fn.filereadable('.vscode/launch.json') then
  --     --     require('dap.ext.vscode').json_decode = require('overseer.json').decode
  --     --     require('dap.ext.vscode').load_launchjs(nil, {
  --     --       ['pwa-node'] = { 'javascript', 'typescript' },
  --     --     })
  --     --   end
  --     --   require('dap').continue(opts)
  --     -- end
  --     -- vim.keymap.set('n', '<Leader>Dd', function()
  --     --   if vim.fn.filereadable('.vscode/launch.json') then
  --     --     require('dap.ext.vscode').json_decode = require('overseer.json').decode
  --     --     require('dap.ext.vscode').load_launchjs(nil, {
  --     --       ['pwa-node'] = { 'javascript', 'typescript' },
  --     --     })
  --     --   end
  --     --   require('fzf-lua').dap_configurations({
  --     --     winopts = {
  --     --       height = 0.3,
  --     --       width = 0.4,
  --     --       row = 0.9,
  --     --       col = 0.9,
  --     --       relative = 'editor',
  --     --     },
  --     --   })
  --     -- end, { desc = 'Start a debugging session' })
  --     -- vim.keymap.set('n', '<Leader>Dc', continue, { desc = 'Continue' })
  --     -- vim.keymap.set('n', '<Leader>Dp', require('dap').pause, { desc = 'Pause' })
  --     -- vim.keymap.set('n', '<Leader>DC', require('dap').run_to_cursor, { desc = 'Continue to cursor' })
  --     -- vim.keymap.set('n', '<Leader>Ds', require('dap').terminate, { desc = 'Stop' })
  --     -- vim.keymap.set('n', '<Leader>Dr', require('dap').restart, { desc = 'Restart' })
  --     -- vim.keymap.set('n', '<Leader>bb', require('dap').toggle_breakpoint, { desc = 'Toggle breakpoint' })
  --     -- vim.keymap.set('n', '<Leader>bc', function()
  --     --   vim.ui.input({ prompt = 'Breakpoint condition: ' }, function(input)
  --     --     if input ~= nil then
  --     --       require('dap').set_breakpoint(input)
  --     --     end
  --     --   end)
  --     -- end, { desc = 'Set conditional breakpoint' })
  --     -- vim.keymap.set('n', '<Leader>bl', function()
  --     --   vim.ui.input({ prompt = 'Logpoint message: ' }, function(input)
  --     --     if input ~= nil then
  --     --       require('dap').set_breakpoint({ nil, nil, input })
  --     --     end
  --     --   end)
  --     -- end, { desc = 'Set Logpoint' })
  --     -- vim.keymap.set('n', '<Leader>B', require('dap').list_breakpoints, { desc = 'List breakpoints' })
  --     -- vim.keymap.set('n', '<Leader>Dv', require('dap').step_over, { desc = 'Step over' })
  --     -- vim.keymap.set('n', '<Leader>Di', require('dap').step_into, { desc = 'Step into' })
  --     -- vim.keymap.set('n', '<Leader>Do', require('dap').step_out, { desc = 'Step out' })
  --     -- vim.keymap.set('n', '<Leader>tr', '<CMD>OverseerRun<CR>', { desc = 'Run task...' })
  --     -- vim.keymap.set('n', '<Leader>tv', '<CMD>OverseerToggle<CR>', { desc = 'Toggle task view' })
  --   end,
  -- },
}
