return {
  {
    'Shatur/neovim-session-manager',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local config = require('session_manager.config')
      require('session_manager').setup({
        autoload_mode = config.AutoloadMode.CurrentDir,
        autosave_ignore_dirs = { '~' }
      })
    end,
  },
  {
    'glepnir/dashboard-nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'gnikdroy/projections.nvim',
      'mrjones2014/legendary.nvim',
    },
    event = 'VimEnter',
    config = function()
      require('dashboard').setup({
        theme = 'hyper',
        disable_move = true,
        change_to_vcs_root = true,
        hide = {
          statusline = false,
        },
        config = {
          week_header = {
            enable = true,
          },
          shortcut = {
            { desc = '  Update', group = '@property', action = 'Lazy sync', key = 'u' },
            {
              desc = '  dotfiles',
              group = 'Number',
              action = function()
                vim.cmd('cd ~/dotfiles')
                vim.cmd('SessionManager load_current_dir_session')
              end,
              key = 'd',
            },
            {
              desc = '  Projects',
              group = 'DiagnosticHint',
              action = 'SessionManager load_session',
              key = 'p',
            },
            {
              desc = '󰈞  Find File',
              group = 'Number',
              action = 'Telescope find_files',
              key = 'f',
            },
            {
              desc = '  New File',
              group = 'Number',
              action = 'enew',
              key = 'n',
            },
          },
          project = {
            enable = true,
            limit = 2,
            icon = '  ',
            label = 'Recent Projects',
            action = function(path)
              vim.cmd('cd ' .. path)
              vim.cmd('SessionManager load_current_dir_session')
            end,
          },
          mru = {
            limit = 3,
          },
          footer = {
            '',
            'Remember to stand up and stretch today!',
          },
        },
      })
    end,
  },
  {
    'stevearc/overseer.nvim',
    config = function ()
      -- TODO set up with NeoTest
      require('overseer').setup({
        strategy = 'toggleterm'
      })
    end
  },

}
