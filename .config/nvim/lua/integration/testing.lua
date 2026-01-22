return {
  {
    'nvim-neotest/neotest',
    version = '^5.13.4',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      -- Test adapters
      'nvim-neotest/neotest-python',
    },
    keys = {
      {
        '<Leader>tt',
        function()
          require('neotest').summary.toggle()
        end,
        mode = { 'n' },
        desc = 'Toggle Tests panel',
      },
      {
        '<Leader>tr',
        function()
          require('neotest').run.run()
        end,
        mode = { 'n' },
        desc = 'Run nearest test',
      },
      {
        '<Leader>tR',
        function()
          require('neotest').run.run(vim.fn.expand('%'))
        end,
        mode = { 'n' },
        desc = 'Run all tests in file',
      },
      {
        '<Leader>tl',
        function()
          require('neotest').run.run_last()
        end,
        mode = { 'n' },
        desc = 'Re-run last test',
      },
      {
        '<Leader>tL',
        function()
          require('neotest').run.run_last({ strategy = 'dap' })
        end,
        mode = { 'n' },
        desc = 'Debug last test',
      },
      {
        '<Leader>td',
        function()
          require('neotest').run.run({ strategy = 'dap' })
        end,
        mode = { 'n' },
        desc = 'Debug nearest test',
      },
      {
        '<Leader>tD',
        function()
          require('neotest').run.run({ vim.fn.expand('%'), strategy = 'dap' })
        end,
        mode = { 'n' },
        desc = 'Debug all tests in file',
      },
      {
        '<Leader>ts',
        function()
          require('neotest').run.stop(vim.fn.expand('%'))
        end,
        mode = { 'n' },
        desc = 'Stop all active tests in file',
      },
      {
        '<Leader>to',
        function()
          require('neotest').output_panel.toggle()
        end,
        mode = { 'n' },
        desc = 'Toggle test output panel',
      },
    },
    config = function()
      require('neotest').setup({
        adapters = {
          require('neotest-python')({ dap = { justMyCode = true, console = 'integratedTerminal' } }),
        },
        icons = {
          running_animated = { '', '', '', '', '', '' },
          skipped = '󰒭',
        },
        status = {
          enabled = true,
          virtual_text = true,
          signs = true,
        },
      })

      Snacks.keymap.set(
        'n',
        'q',
        '<CMD>close<CR>',
        { ft = { 'neotest-output', 'neotest-output-panel' }, desc = 'Close panel' }
      )
    end,
  },
}
