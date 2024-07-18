local util = require('util')
return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      -- Ensure loading after ts parser added
      'LiadOz/nvim-dap-repl-highlights'
    },
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = require('config.sources').treesitter,
        auto_install = true,
        highlight = {
          enable = true,
          language_tree = true,
          disable = function(lang, bufnr)
            local max_filesize = 1024 * 1024 -- 1MB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
            if ok and stats and stats.size > max_filesize then
              return true
            end
            return false
          end,
        },
      })
      local ts_parsers = require('nvim-treesitter.parsers')
      -- Add Hurl support
      vim.tbl_extend('force', ts_parsers.get_parser_configs().hurl, {
        install_info = {
          url = 'https://github.com/kjuulh/tree-sitter-hurl',
          files = { 'src/parser.c' },
        },
        filetype = '*.hurl*',
      })
      vim.filetype.add({
        pattern = { ['.*.hurl.*'] = 'hurl' },
      })
      -- Auto-install parsers when entering filetype for first time
      -- vim.api.nvim_create_autocmd('BufEnter', {
      --   pattern = { '*' },
      --   callback = function()
      --     local ft = vim.bo.filetype
      --     if not ft or require('config.filetype_excludes')[ft] ~= nil then
      --       return
      --     end
      --     local parser = ts_parsers.filetype_to_parsername[ft]
      --     if not parser then
      --       return
      --     end
      --     local is_installed = ts_parsers.has_parser(ts_parsers.ft_to_lang(ft))
      --     if not is_installed then
      --       vim.cmd('TSInstall ' .. parser)
      --     end
      --   end,
      -- })

      -- Set special pyenv virtualenv
      vim.g.python3_host_prog = '~/.pyenv/versions/py3nvim/bin/python'
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('nvim-treesitter.configs').setup({
        textobjects = {
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = { query = '@class.outer', desc = 'Next class start' },
              [']s'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' },
              [']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
            -- Below will go to either the start or the end, whichever is closer.
            -- Use if you want more granular movements
            -- Make it even more gradual by adding multiple queries and regex.
            goto_next = {
              [']d'] = '@conditional.outer',
            },
            goto_previous = {
              ['[d'] = '@conditional.outer',
            },
          },
        },
      })
      local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')

      -- Repeat movement with ; and ,
      -- vim way: ; goes to the direction you were moving.
      vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move)
      vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_opposite)

      -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f)
      vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F)
      vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t)
      vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T)
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('treesitter-context').setup({
        max_lines = 3,
      })
    end,
  },
}
