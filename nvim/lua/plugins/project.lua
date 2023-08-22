return {
  {
    'rmagatti/auto-session',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('auto-session').setup({
        log_level = 'error',
        auto_session_supress_dirs = { '~' },
        auto_session_use_git_branch = false,
        restore_upcoming_session = true,
        pre_save_cmds = {
          'ScopeSaveState',
          'NeoTreeClose',
          function()
            require('spectre').close()
          end,
        },
        post_restore_cmds = { 'ScopeLoadState' },
        session_lens = {
          path_display = { 'truncate' },
          theme = 'vertical',
          previewer = false,
        },
      })

      vim.keymap.set('n', '<Leader>fp', require('auto-session.session-lens').search_session, { desc = 'Find Project' })
    end,
  },
  {
    'ethanholz/nvim-lastplace',
    config = function()
      local exclude = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' }
      local n = #exclude
      for _, v in ipairs(require('config.filetype_excludes')) do
        n = n + 1
        exclude[n] = v
      end
      require('nvim-lastplace').setup({
        lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help' },
        lastplace_ignore_filetype = exclude,
        lastplace_open_folds = true,
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
      local motd = {
        'Remember to stand up and stretch today!',
        'When in doubt, :checkhealth!',
      }
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
                vim.cmd([[SessionRestore]])
              end,
              key = 'd',
            },
            {
              desc = '  Projects',
              group = 'DiagnosticHint',
              action = 'Autosession search',
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
              vim.cmd([[SessionRestore]])
            end,
          },
          mru = {
            limit = 3,
          },
          footer = {
            '',
            motd[math.random(#motd)],
          },
        },
      })
    end,
  },
  {
    'stevearc/overseer.nvim',
    config = function()
      -- TODO set up with NeoTest
      require('overseer').setup({
        strategy = 'toggleterm',
      })
    end,
  },
}
