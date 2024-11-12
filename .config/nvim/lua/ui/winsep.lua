return {
  {
    'nvim-zh/colorful-winsep.nvim',
    event = { 'WinLeave' },
    config = function()
      require('colorful-winsep').setup({
        symbols = { '─', '│', '┌', '┐', '└', '┘' },
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
}
