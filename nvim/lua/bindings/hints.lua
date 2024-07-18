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
        { '<Leader>f', group = 'Find...' },
        { '<Leader>s', group = 'Select...' },
        { '<Leader>g', group = 'Global...' },
        { '<Leader>m', group = 'Manage...' },
        { '<Leader>j', group = 'Jump...' },
        -- { '<Leader>v', group = 'View...' },
        { '<Leader>e', group = 'Explore / Explain...' },
        { '<Leader>t', group = 'Terminal / Toggle / Task...' },
        { '<Leader>o', group = 'Options...' },
        { '<Leader>r', group = 'Replace / Request...' },
        { '<Leader>D', group = 'Debugging...' },
        { '<Leader>d', group = 'Diff / Detect...' },
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
  {
    'mrjones2014/legendary.nvim',
    priority = 10000,
    lazy = false,
    dependencies = {
      'folke/which-key.nvim',
    },
    config = function()
      require('legendary').setup({
        extensions = {
          diffview = true,
          which_key = {
            auto_register = true,
          },
        },
        select_prompt = '> ',
        col_separator_char = '',
        keymaps = {
          { -- Summon Command palette
            '<Leader><Leader>',
            function()
              local legendary, filters = require('legendary'), require('legendary.filters')
              legendary.find({
                filters = {
                  filters.OR(
                    filters.AND(filters.keymaps(), filters.current_mode()),
                    filters.commands(),
                    filters.OR(),
                    filters.funcs()
                  ),
                },
              })
            end,
            description = 'Open command palette',
          },
        },
      })
    end,
  },
}
