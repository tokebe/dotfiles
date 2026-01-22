return {
  {
    'folke/which-key.nvim',
    lazy = false,
    config = function()
      local which_key = require('which-key')
      which_key.setup({
        icons = {
          group = '» ',
        },
        layout = {
          align = 'center',
        },
      })
      which_key.add({
        { '<Leader>_', group = 'Hydras' },
        { '<Leader>f', group = 'Find...' },
        { '<Leader>s', group = 'Select...' },
        { '<Leader>g', group = 'Global / Git...' },
        { '<Leader>m', group = 'Manage / Multicursor...' },
        { '<Leader>j', group = 'Jump...' },
        -- { '<Leader>v', group = 'View...' },
        { '<Leader>e', group = 'Explore / Explain...' },
        { '<Leader>t', group = 'Test / Task...' },
        { '<Leader>o', group = 'Options...' },
        { '<Leader>ot', group = 'Toggles...' },
        { '<Leader>r', group = 'Replace / Request...' },
        { '<Leader>d', group = 'Debugging...' },
        { '<Leader>h', group = 'Hunk...' },
        { '<Leader>p', group = 'Project...' },
        { '<Leader>u', group = 'URL...' },
        { '<Leader>q', group = 'Quit / session...' },
        { '<Leader>b', group = 'Breakpoint...' },
        { '<Leader>w', group = 'Window / Buffer...' },
      })
      -- Set up misc keybinds
      require('config.misc-keybinds')
    end,
  },
}
