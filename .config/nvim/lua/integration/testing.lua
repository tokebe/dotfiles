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
        '<Leader>Tt',
        function()
          require('neotest').summary.toggle()
        end,
        mode = { 'n' },
        desc = 'Toggle Tests panel',
      },
      {
        '<Leader>Tr',
        function()
          require('neotest').run.run()
        end,
        mode = { 'n' },
        desc = 'Run nearest test',
      },
      {
        '<Leader>TR',
        function()
          require('neotest').run.run(vim.fn.expand('%'))
        end,
        mode = { 'n' },
        desc = 'Run all tests in file',
      },
      {
        '<Leader>Tl',
        function()
          require('neotest').run.run_last()
        end,
        mode = { 'n' },
        desc = 'Re-run last test',
      },
      {
        '<Leader>TL',
        function()
          require('neotest').run.run_last({ strategy = 'dap' })
        end,
        mode = { 'n' },
        desc = 'Debug last test',
      },
      {
        '<Leader>Td',
        function()
          require('neotest').run.run({ strategy = 'dap' })
        end,
        mode = { 'n' },
        desc = 'Debug nearest test',
      },
      {
        '<Leader>TD',
        function()
          require('neotest').run.run({ vim.fn.expand('%'), strategy = 'dap' })
        end,
        mode = { 'n' },
        desc = 'Debug all tests in file',
      },
      {
        '<Leader>Ts',
        function()
          require('neotest').run.stop(vim.fn.expand('%'))
        end,
        mode = { 'n' },
        desc = 'Stop all active tests in file',
      },
      {
        '<Leader>Tt',
        function()
          require('neotest').summary.toggle()
        end,
        mode = { 'n' },
        desc = 'Toggle Tests panel',
      },
      {
        '<Leader>To',
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
          require('neotest-python')({ dap = { justMyCode = true, console = 'externalTerminal' } }),
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
