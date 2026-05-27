require('config.misc-keybinds')
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
        { '<Leader>b', group = 'Breakpoint...', icon = ' ' },
        { '<Leader>d', group = 'Debugging...' },
        { '<Leader>e', group = 'Explore / Explain...', icon = '󰍉 ' },
        { '<Leader>f', group = 'Find...' },
        { '<Leader>g', group = 'Global / Git...', icon = ' ' },
        { '<Leader>h', group = 'Hunk...', icon = ' ' },
        { '<Leader>i', group = 'Insert / Inlays...', icon = ' ' },
        { '<Leader>m', group = 'Manage / Multicursor...', icon = '' },
        { '<Leader>o', group = 'Options...', icon = ' '  },
        { '<Leader>ot', group = 'Toggles...' },
        { '<Leader>p', group = 'Project...', icon = '󰏓 ' },
        { '<Leader>q', group = 'Quit / session...' },
        { '<Leader>r', group = 'Replace / Request...', icon = '󰛔 ' },
        { '<Leader>s', group = 'Select...', icon = '󰒅 ' },
        -- { '<Leader>v', group = 'View...' },
        { '<Leader>t', group = 'Test / Task...', icon = '󰙨 ' },
        { '<Leader>u', group = 'URL...', icon = '󰌷 ' },
        { '<Leader>w', group = 'Window / Buffer...', icon = ' ' },
      })
      -- Set up misc keybinds
    end,
  },
}
