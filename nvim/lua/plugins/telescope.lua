return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-live-grep-args.nvim' }, -- ripgrep args
      { 'stevearc/dressing.nvim' }, -- better UI for a few things
      { 'mrjones2014/legendary.nvim' },
    },
    config = function()
      local telescope = require('telescope')
      telescope.setup({
        border = {},
        pickers = {
          colorscheme = {
            enable_preview = true
          }
        }
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
      require('legendary').setup({
        which_key = {
          auto_register = true,
        },
        col_separator_char = ' ',
        extensions = {
          nvim_tree = false,
          smart_splits = false,
          op_nvim = false,
          diffview = false,
        },
      })
    end,
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable('make') == 1
    end,
    config = function()
      require('telescope').load_extension('fzf')
    end,
  },
}
