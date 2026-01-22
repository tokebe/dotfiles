local util = require('util')
return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    dependencies = {
      -- Ensure loading after ts parser added
      -- 'LiadOz/nvim-dap-repl-highlights',
    },
    config = function()
      require('nvim-treesitter.config').setup({
        ensure_installed = require('config.sources').treesitter,
        sync_install = false,
        auto_install = true,
        ignore_install = {},
        modules = {},
        indent = { enable = true, disable = { 'python' } },
        highlight = {
          enable = true,
          language_tree = true,
          additional_vim_regex_highlighting = false,
          disable = function(_lang, bufnr)
            local max_filesize = 1024 * 1024 -- 1MB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
            if ok and stats and stats.size > max_filesize then
              return true
            end
            return false
          end,
        },
        -- textobjects = {
        --   move = {
        --     enable = true,
        --     set_jumps = true, -- whether to set jumps in the jumplist
        --     goto_next_start = {
        --       [']m'] = '@function.outer',
        --       [']]'] = { query = '@class.outer', desc = 'Next class start' },
        --       [']s'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' },
        --       [']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
        --     },
        --     goto_next_end = {
        --       [']M'] = '@function.outer',
        --       [']['] = '@class.outer',
        --     },
        --     goto_previous_start = {
        --       ['[m'] = '@function.outer',
        --       ['[['] = '@class.outer',
        --     },
        --     goto_previous_end = {
        --       ['[M'] = '@function.outer',
        --       ['[]'] = '@class.outer',
        --     },
        --     -- Below will go to either the start or the end, whichever is closer.
        --     -- Use if you want more granular movements
        --     -- Make it even more gradual by adding multiple queries and regex.
        --     goto_next = {
        --       [']d'] = '@conditional.outer',
        --     },
        --     goto_previous = {
        --       ['[d'] = '@conditional.outer',
        --     },
        --   },
        -- },
      })
      -- local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')

      -- -- Repeat movement with ; and ,
      -- -- vim way: ; goes to the direction you were moving.
      -- vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move)
      -- vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_opposite)
      --
      -- -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
      -- vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr)
      -- vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr)
      -- vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr)
      -- vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr)

      -- Set special pyenv virtualenv
      -- vim.g.python3_host_prog = '~/.pyenv/versions/py3nvim/bin/python'
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    config = function()
      require('nvim-treesitter-textobjects').setup({
        move = {
          set_jumps = true,
        },
        select = {
          lookahead = true,
          selection_modes = {
            ['@parameter.outer'] = 'v',
            ['@function.outer'] = 'V',
            include_surrounding_whitespace = false,
          },
        },
      })

      vim.keymap.set({ 'x', 'o' }, 'am', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'im', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'ac', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'ic', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
      end)
      -- You can also use captures from other query groups like `locals.scm`
      vim.keymap.set({ 'x', 'o' }, 'as', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals')
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects')
      end)
      -- You can also pass a list to group multiple queries.
      vim.keymap.set({ 'n', 'x', 'o' }, ']o', function()
        require('nvim-treesitter-textobjects.move').goto_next_start({ '@loop.inner', '@loop.outer' }, 'textobjects')
      end)
      -- You can also use captures from other query groups like `locals.scm` or `folds.scm`
      vim.keymap.set({ 'n', 'x', 'o' }, ']s', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@local.scope', 'locals')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, ']z', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@fold', 'folds')
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
        require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '][', function()
        require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects')
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
        require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
        require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects')
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
        require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[]', function()
        require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects')
      end)

      -- Go to either the start or the end, whichever is closer.
      -- Use if you want more granular movements
      vim.keymap.set({ 'n', 'x', 'o' }, ']d', function()
        require('nvim-treesitter-textobjects.move').goto_next('@conditional.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[d', function()
        require('nvim-treesitter-textobjects.move').goto_previous('@conditional.outer', 'textobjects')
      end)

      local ts_repeat_move = require('nvim-treesitter-textobjects.repeatable_move')

      -- Repeat movement with ; and ,
      -- ensure ; goes forward and , goes backward regardless of the last direction
      vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
      vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)

      -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('treesitter-context').setup({
        enable = true,
        max_lines = 3,
        multiwindow = false,
      })
      vim.keymap.set('n', '<Leader>otx', '<CMD>TSContext toggle<CR>', { desc = 'Toggle top context' })
      vim.api.nvim_create_autocmd('UIEnter', {
        command = 'TSContext enable',
        desc = 'Ensure re-opened buffer has context enabled.',
      })
    end,
  },
}
