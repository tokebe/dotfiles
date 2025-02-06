return {
  {
    'Shatur/neovim-session-manager',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/overseer.nvim',
      { 'tiagovla/scope.nvim', commit = 'f8a6783' },
    },
    config = function()
      local config = require('session_manager.config')
      require('scope').setup()
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
          -- overseer.save_task_bundle(util.get_cwd_as_name(), nil, { on_conflict = 'overwrite' })
        end,
      })

      vim.api.nvim_create_autocmd({ 'User' }, {
        pattern = 'SessionLoadPost',
        group = config_group,
        callback = function()
          vim.cmd('ScopeLoadState')
          -- for _, task in ipairs(overseer.list_tasks({})) do
          --   task:dispose(true)
          -- end
          -- overseer.load_task_bundle(util.get_cwd_as_name(), { ignore_missing = true })
        end,
      })
      vim.keymap.set('n', '<Leader>pp', function()
        vim.cmd('SessionManager load_session')
      end, { desc = 'Find Project (session)' })
      vim.keymap.set('n', '<Leader>ps', function()
        vim.cmd('SessionManager save_current_session')
      end, { desc = 'Save Project (session)' })
      vim.keymap.set('n', '<Leader>pd', function()
        vim.cmd('SessionManager delete_session')
      end, { desc = 'Delete Project (session)' })

      vim.keymap.set('n', '<Leader>qs', ':SessionManager save_current_session<CR>', {
        desc = 'Save current session',
      })
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
      'ibhagwan/fzf-lua',
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
            {
              desc = '󰘪  Quit',
              group = 'DiagnosticHint',
              action = function()
                vim.cmd('qa')
              end,
              key = 'q',
            },
            {
              desc = '  Update',
              group = '@property',
              action = function()
                vim.cmd('Lazy sync')
                vim.cmd('TSUpdate')
              end,
              key = 'u',
            },
            {
              desc = '  dotfiles',
              group = 'Number',
              action = function()
                vim.cmd('cd ~/.dotfiles')
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
              desc = '  Find Directory',
              group = 'DiagnosticHint',
              action = function()
                require('fzf-lua').files({
                  fd_opts = '--type d',
                  cwd = '~',
                  actions = {
                    ['default'] = function(selected)
                      -- Remove icon, don't sub() if icons disabled
                      local path = selected[1]:sub(7)
                      vim.cmd('cd ~/' .. path)
                    end,
                  },
                })
              end,
              key = 'F',
            },
            {
              desc = '󰈞  Find File',
              group = 'Number',
              action = function()
                require('fzf-lua').files({
                  fd_opts = '--no-ignore --hidden --type f',
                  winopts = {
                    preview = {
                      layout = 'vertical',
                      vertical = 'up',
                    },
                  },
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
            limit = 2, -- Should be 3 but apparently it can't count
            icon = '  ',
            label = 'Recent Projects',
            action = function(path)
              vim.cmd('cd ' .. path)
              vim.cmd('SessionManager load_current_dir_session')
            end,
          },
          mru = {
            limit = 3,
            icon = '󱋡  ',
            label = 'Recent Files',
          },
          footer = {
            '',
            motd[math.random(#motd)],
          },
        },
      })
      vim.keymap.set('n', '<Leader>qd', function()
        vim.cmd('cd ~')
        vim.cmd('only')
        vim.cmd('windo bd')
        vim.cmd('Dashboard')
      end, {
        desc = 'Quit to dashboard',
      })
    end,
  },
  {
    'stevearc/overseer.nvim',
    config = function()
      require('overseer').setup({
        strategy = 'toggleterm',
      })
    end,
  },
}
