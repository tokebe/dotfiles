return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-live-grep-args.nvim' }, -- ripgrep args
      { 'stevearc/dressing.nvim' }, -- better UI for a few things
      { 'LukasPietzschmann/telescope-tabs' },
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      telescope.setup({
        border = {},
        pickers = {
          colorscheme = {
            enable_preview = true,
          },
          buffers = {
            mappings = {
              i = {
                ['<Esc>'] = actions.close,
                ['<tab>'] = 'select_default',
              },
            },
          },
        },
        extensions = {
          live_grep_args = {
            auto_quoting = true,
          },
        },
      })
      telescope.load_extension('live_grep_args')
      -- Set up dressing (ui enhancements)
      require('dressing').setup({
        input = {
          border = 'none',
        },
        select = {
          get_config = function(opts)
            if opts.kind == 'legendary.nvim' then
              return {
                telescope = {
                  sorter = require('telescope.sorters').fuzzy_with_index_bias(),
                },
              }
            else
              return {}
            end
          end,
          telescope = require('telescope.themes').get_dropdown({
            layout_config = {
              width = 0.8,
            },
          }),
        },
      })
    end,
  },
  {
    'debugloop/telescope-undo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'debugloop/telescope-undo.nvim',
    },
    config = function()
      require('telescope').load_extension('undo')
    end,
  },
  {
    'ibhagwan/fzf-lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local actions = require('fzf-lua.actions')
      require('fzf-lua').setup({
        actions = {
          buffers = {
            ['tab'] = actions.file_edit,
          },
        },
        fzf_opts = {
          ['--layout'] = 'default',
        },
        buffers = {
          ignore_current_buffer = true,
        },
      })
    end,
  },
}
