return {
  config = function()
    -- Create highlights for the types of breakpoints
    local set_namespace = vim.api.nvim__set_hl_ns or vim.api.nvim_set_hl_ns
    local namespace = vim.api.nvim_create_namespace('dap-hlng')
    vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939', bg = '#31353f' })
    vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '#31353f' })
    vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bg = '#31353f' })

    vim.fn.sign_define('DapBreakpoint', { text = ' ', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointCondition', { text = ' ', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointRejected', { text = ' ', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapLogPoint', { text = ' ', texthl = 'DapLogPoint', numhl = 'DapLogPoint' })
    vim.fn.sign_define('DapStopped', { text = ' ', texthl = 'DapStopped', numhl = 'DapStopped' })

    -- Set up DAP
    require('mason-nvim-dap').setup({
      automatic_setup = true,
      ensure_installed = require('config.sources').dap,
    })
    require('dap.ext.vscode').load_launchjs()
    -- TODO add commands
    require('telescope').load_extension('dap')
    -- TODO change all breakpoint toggles to use persistent_breakpoints
    require('persistent-breakpoints').setup({
      load_breakpoints_event = { 'BufReadPost' },
    })
    require('nvim-dap-virtual-text').setup({
      all_references = true,
      commented = true,
    })
    require('dapui').setup({
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
      mappings = {
        edit = 'e',
        expand = { '<CR>', '<2-LeftMouse>' },
        open = 'o',
        remove = 'd',
        repl = 'r',
        toggle = 't',
      },
      render = {
        indent = 1,
        max_value_lines = 100,
      },
    })
  end,
}
