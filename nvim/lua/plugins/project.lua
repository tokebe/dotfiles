return {
  {
    'gnikdroy/projections.nvim',
    config = function()
      require('projections').setup({
        workspaces = {
          { '~/Documents/GitHub', { '.git', '.vscode' } },
          { '~',                  { '.git', '.vscode' } },
        },
        store_hooks = {
          pre = function() -- Avoid problems with nvim-tree
            local nvim_tree_present, api = pcall(require, 'nvim-tree.api')
            if nvim_tree_present then
              api.tree.close()
            end
          end,
        },
      })
      require('telescope').load_extension('projections')
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
            { desc = ' Update', group = '@property', action = 'Lazy sync', key = 'u' },
            {
              desc = ' dotfiles',
              group = 'Number',
              action = 'cd ~/dotfiles',
              key = 'd',
            },
            {
              desc = ' Projects',
              group = 'DiagnosticHint',
              action = 'Telescope projections',
              key = 'p',
            },
            {
              -- TODO when you have icons fixed use 
              desc = '+New File',
              group = 'Number',
              action = 'enew',
              key = 'f',
            },
          },
          project = {
            enable = true,
            limit = 8,
            icon = ' ',
            label = 'Recent Projects',
            action = function(path)
              vim.cmd('cd ' .. path)
            end,
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
    'EthanJWright/vs-tasks.nvim',
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
  },
}
