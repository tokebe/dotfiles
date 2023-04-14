return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-live-grep-args.nvim' }, -- ripgrep args
      { 'stevearc/dressing.nvim' },                       -- better UI for a few things
      { 'mrjones2014/legendary.nvim' },
    },
    config = function()
      local telescope = require('telescope')
      telescope.setup({
        border = {}
      })
      telescope.load_extension('live_grep_args')
      -- Set up which-key section
      require('which-key').register({
        ['<leader>f'] = {
          name = "Find..."
        }
      })
      -- Set up keymaps
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', function() builtin.find_files({ no_ignore = true }) end, {
        desc = "Find file"
      })
      vim.keymap.set('n', '<leader>fg', telescope.extensions.live_grep_args.live_grep_args, {
        desc = "Find grep"
      })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {
        desc = "Find buffer"
      })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {
        desc = "Find help tag"
      })
      vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, {
        desc = "Find symbol in buffer"
      })
      vim.keymap.set('n', '<leader>fd', builtin.diagnostics, {
        desc = "Find diagnostics"
      })
      vim.keymap.set('n', '<leader>fw', builtin.lsp_dynamic_workspace_symbols, {
        desc = "Find symbol in workspace"
      })
      -- Set up dressing (ui enhancements)
      require('dressing').setup({
        input = {
          border = "none",
        },
        select = {
          get_config = function(opts)
            if opts.kind == 'legendary.nvim' then
              return {
                telescope = {
                  sorter = require('telescope.sorters').fuzzy_with_index_bias()
                }
              }
            else
              return {}
            end
          end,
          telescope = require('telescope.themes').get_dropdown({
            layout_config = {
              width = 0.8
            }
          })
        }
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
        }
      })
    end
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
    config = function()
      require('telescope').load_extension('fzf')
    end
  },
}
