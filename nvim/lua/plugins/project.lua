return {
  -- {
  --   'rmagatti/auto-session',
  --   config = function()
  --     require('auto-session').setup({
  --       log_level = 'error',
  --       auto_session_supress_dirs = { '~' },
  --       auto_session_use_git_branch = false,
  --       restore_upcoming_session = true,
  --       pre_save_cmds = {
  --         'ScopeSaveState',
  --         'NeoTreeClose',
  --         function()
  --           require('spectre').close()
  --         end,
  --       },
  --       post_restore_cmds = { 'ScopeLoadState' },
  --       session_lens = {
  --         path_display = { 'truncate' },
  --         theme = 'vertical',
  --         previewer = false,
  --       },
  --     })
  --
  --     vim.keymap.set('n', '<Leader>fp', ':Autosession search<CR>', { desc = 'Find Project' })
  --     vim.keymap.set('n', '<Leader>dp', ':Autosession delete<CR>', { desc = 'Delete Project' })
  --   end,
  -- },
  -- {
  --   'gennaro-tedesco/nvim-possession',
  --   dependencies = {
  --     'ibhagwan/fzf-lua',
  --   },
  --   config = function()
  --     require('nvim-possession').setup({
  --       autoload = true,
  --       autosave = true,
  --       autoswitch = {
  --         enable = true,
  --         -- exclude_ft = require('config.filetype_excludes'),
  --       },
  --       save_hook = function()
  --         vim.cmd('ScopeSaveState')
  --       end,
  --       post_hook = function()
  --         vim.cmd('ScopeLoadState')
  --       end,
  --     })
  --     vim.keymap.set('n', '<Leader>pp', function()
  --       require('nvim-possession').list()
  --     end, { desc = 'Find Project' })
  --     vim.keymap.set('n', '<Leader>pn', function()
  --       require('nvim-possession').new()
  --     end, { desc = 'New Project' })
  --   end,
  -- },
  {
    'Shatur/neovim-session-manager',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local config = require('session_manager.config')
      require('session_manager').setup({
        autoload_mode = config.AutoloadMode.CurrentDir,
        autosave_ignore_dirs = { '~' },
        -- autosave_ignore_filetypes = require('config.filetype_excludes'),
        autosave_ignore_not_normal = true,
        autosave_only_in_session = true,
      })

      local config_group = vim.api.nvim_create_augroup('MyConfigGroup', {}) -- A global group for all your config autocommands

      vim.api.nvim_create_autocmd({ 'User' }, {
        pattern = 'SessionSavePre',
        group = config_group,
        callback = function()
          vim.cmd('ScopeSaveState')
        end,
      })

      vim.api.nvim_create_autocmd({ 'User' }, {
        pattern = 'SessionLoadPost',
        group = config_group,
        callback = function()
          vim.cmd('ScopeLoadState')
        end,
      })
      vim.keymap.set('n', '<Leader>pp', function()
        vim.cmd('SessionManager load_session')
      end, { desc = 'Find Project (session)' })
      vim.keymap.set('n', '<Leader>ps', function()
        vim.cmd('SessionManager save_current_session')
      end, { desc = 'Save Project (session)' })
      vim.keymap.set('n', '<Leader>pd', function()
        vim.cmd('SessionManager save_current_session')
      end, { desc = 'Delete Project (session)' })
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
                vim.cmd('SessionManager load_current_dir_session')
              end,
              key = 'd',
            },
            {
              desc = '  Projects',
              group = 'DiagnosticHint',
              action = function()
                vim.cmd('SessionManager load_session')
              end,
              key = 'p',
            },
            {
              desc = '󰈞  Find File',
              group = 'Number',
              action = function()
                require('fzf-lua').files({
                  fd_opts = '--no-ignore --hidden --type f',
                })
              end,
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
