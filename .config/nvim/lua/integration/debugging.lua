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
      'nvimtools/hydra.nvim',
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
      -- dap.defaults.fallback.switchbuf = 'usevisible,usetab,newtab'

      -- Open dap-view whenever a debug session starts
      dap.listeners.before.launch.dap_view = function()
        require('dap-view').open()
      end

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
          -- Don't wait for subprocesses
          config.subProcess = false
          -- Force config to use integratedTerminal
          config.console = 'integratedTerminal'
          on_config(config)
        end,
      }

      -- Override default python launch config so it uses the above debugpy adapter
      dap.configurations.python = {
        {
          type = 'debugpy',
          request = 'launch',
          name = 'Launch current file',
          program = '${file}',
        },
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

      -- Provides a decent UI, might switch back to dap-ui for toggleable breakpoints
      local dapview = require('dap-view')
      dapview.setup({
        auto_toggle = false,
        winbar = {
          default_section = 'console',
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

      -- Breakpoint keybinds
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

      -- Debugging keybinds
      vim.keymap.set('n', '<Leader>dd', dap.continue, { desc = 'Start a debugging session...' })
      vim.keymap.set('n', '<Leader>dv', dapview.toggle, { desc = 'Toggle debugging UI' })

      vim.keymap.set('n', '<Leader>dp', dap.pause, { desc = 'Pause' })
      vim.keymap.set('n', '<Leader>dc', dap.continue, { desc = 'Continue' })
      vim.keymap.set('n', '<Leader>dC', dap.run_to_cursor, { desc = 'Continue to cursor' })
      vim.keymap.set('n', '<Leader>ds', dap.terminate, { desc = 'Stop' })
      vim.keymap.set('n', '<Leader>dr', dap.restart, { desc = 'Restart' })
      vim.keymap.set('n', '<Leader>df', '<CMD>FzfLua dap_breakpoints<CR>', { desc = 'Find breakpoints' })
      vim.keymap.set('n', '<Leader>dj', dap.step_over, { desc = 'Step over' })
      vim.keymap.set('n', '<Leader>dl', dap.step_into, { desc = 'Step into' })
      vim.keymap.set('n', '<Leader>dh', dap.step_out, { desc = 'Step out' })

      -- Debug control mode
      require('hydra')({
        name = 'Debug',
        mode = 'n',
        body = '<Leader>dm',
        config = {
          color = 'pink',
          invoke_on_body = true,
          desc = 'Debug control mode',
          hint = {
            type = 'window',
          },
        },
        heads = {
          { 'c', dap.continue, { exit = false, nowait = true, desc = 'Continue' } },
          { 'C', dap.run_to_cursor, { exit = false, nowait = true, desc = 'Continue to cursor' } },
          { 'J', dap.step_over, { exit = false, nowait = true, desc = 'Step over' } },
          { 'L', dap.step_into, { exit = false, nowait = true, desc = 'Step into' } },
          { 'H', dap.step_out, { exit = false, nowait = true, desc = 'Step out' } },
        },
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
  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-dap-virtual-text').setup({
        virt_lines = true,
      })
    end,
  },
}
