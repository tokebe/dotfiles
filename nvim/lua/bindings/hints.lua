return {
  {
    'folke/which-key.nvim',
    lazy = false,
    config = function()
      local which_key = require('which-key')
      which_key.setup({
        icons = {
          group = '»',
        },
        layout = {
          align = 'center',
        },
      })
      which_key.register({
        f = { name = 'Find...' },
        s = { name = 'Select...' },
        g = { name = 'Global...' },
        m = { name = 'Manage...' },
        j = { name = 'Jump...' },
        -- v = { name = 'View...' },
        e = { name = 'Explore / Explain...' },
        t = { name = 'Terminal / Toggle / Task...' },
        o = { name = 'Options...' },
        r = { name = 'Replace / Request...' },
        D = { name = 'Debugging...' },
        d = { name = 'Diff...' },
        h = { name = 'Hunk...' },
        p = { name = 'Project...' },
        u = { name = 'URL...' },
        q = { name = 'Quit / session...' }
      }, { prefix = '<Leader>' })
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
        },
        select_prompt = '> ',
        col_separator_char = '',
        which_key = {
          auto_register = true,
        },
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
