-- Make Esc hide search highlight in normal mode
vim.api.nvim_set_keymap('n', '<Esc>', ':noh<CR>', { noremap = true, silent = true })
return {
  'mrjones2014/legendary.nvim',
  dependencies = {
    'folke/which-key.nvim',
  },
  config = function()
    local wk = require('which-key')
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')
    require('legendary').setup({
      keymaps = {
        -- Summon Command palette
        {
          '<leader><leader>',
          ':Legendary<CR>',
          description = 'Open command palette',
        },
        -- Find keymaps
        {
          '<leader>ff',
          function()
            builtin.find_files({ no_ignore = true })
          end,
          description = 'Find file',
        },
        {
          '<leader>fg',
          telescope.extensions.live_grep_args.live_grep_args,
          description = 'Find in files (grep)',
        },
        {
          '<leader>fb',
          builtin.buffers,
          description = 'Find open buffer',
        },
        {
          '<leader>fh',
          builtin.help_tags,
          description = 'Find help',
        },
        {
          '<leader>fs',
          builtin.lsp_document_symbols,
          description = 'Find symbol in buffer',
        },
        {
          '<leader>fS',
          builtin.lsp_dynamic_workspace_symbols,
          description = 'Find symbol in workspace',
        },
        {
          '<leader>fd',
          builtin.diagnostics,
          description = 'Find diagnostics',
        },
        {
          '<leader>fr',
          builtin.lsp_references,
          description = 'Find references',
        },
        {
          '<leader>ft',
          builtin.current_buffer_fuzzy_find,
          description = 'Find text in buffer',
        },
        {
          '<leader>fq',
          builtin.quickfix,
          description = 'Find quickfix',
        },
        -- Select keymaps
        {
          '<leader>sl',
          builtin.filetypes,
          description = 'Select language',
        },
        {
          '<leader>sb',
          builtin.git_branches,
          description = 'Select branch',
        },
        {
          '<leader>sc',
          builtin.colorscheme,
          description = 'Select colorscheme',
        },
        -- Global operation keymaps
        {
          '<leader>gf',
          {
            n = function()
              vim.lsp.buf.format({ async = true })
            end,
            v = function()
              vim.lsp.buf.format({
                async = true,
                range = {
                  ['start'] = vim.api.nvim_buf_get_mark(0, '<'),
                  ['end'] = vim.api.nvim_buf_get_mark(0, '>'),
                },
              })
            end,
          },
          description = 'Format',
        },
        {
          '<leader>gr',
          function()
            return ':IncRename ' .. vim.fn.expand('<cword>')
          end,
          description = 'Rename symbol',
        },
        -- Jump kebinds
        {
          '<leader>jb',
          ':Portal jumplist backward<CR>',
          description = 'Jump backward in place history',
        },
        {
          '<leader>jf',
          ':Portal jumplist forward<CR>',
          description = 'Jump forward in place history',
        },
        -- Manage	keybinds
        {
          '<leader>ms',
          ':Navbuddy<CR>',
          description = 'Manage symbols with Navbuddy',
        },
        -- Tree keybinds
        {
          '<leader>tt',
          ':NvimTreeToggle<CR>',
          description = 'Toggle tree',
        },
        {
          '<leader>tf',
          ':NvimTreeFocus<CR>',
          description = 'Focus tree',
        },
        {
          '<leader>tj',
          ':NvimTreeFindFile<CR>',
          description = 'Jump to current buffer in tree',
        },
        {
          '<leader>tc',
          ':NvimTreeCollapse<CR>',
          description = 'Recursively collapse tree',
        },
        -- Option/toggle keybinds
        {
          '<leader>oa',
          ':ASToggle<CR>',
          description = 'Toggle autosave',
        },
        {
          '<leader>om',
          ':Mason<CR>',
          description = 'Manage LSPs with Mason',
        },
        {
          '<leader>op',
          ':Lazy<CR>',
          description = 'Manage plugins with Lazy',
        },
        -- Buffer keybinds
        {
          '<lt>',
          ':BufferPrevious<CR>',
          description = 'Next buffer',
        },
        {
          '>',
          ':BufferNext<CR>',
          description = 'Previous buffer',
        },
        {
          '<A-lt>',
          ':BufferMovePrevious<CR>',
          description = 'Move buffer tab left',
        },
        {
          '<A->>',
          ':BufferMoveNext<CR>',
          description = 'Move buffer tab right',
        },
        -- Misc keybinds
        {
          '<leader>bd',
          ':BufferClose<CR>',
          description = 'Close buffer',
        },
        -- Fold controls for UFO
        {
          'zR',
          require('ufo').openAllFolds,
          description = 'Open all folds',
        },
        {
          'zM',
          require('ufo').closeAllFolds,
          description = 'Close all folds',
        },
      },
      commands = {},
      funcs = {},
      autocmds = {
        {
          'QuitPre',
          function()
            vim.cmd('NvimTreeClose')
          end,
          description = 'Close nvim-tree before quit so nvim actually quits',
        },
      },
      extensions = {},
      col_separator_char = ' ',
      which_key = {
        auto_register = true,
      },
    })
    -- Add group names to which_key
    wk.register({
      -- Find keymaps
      f = { name = 'Find...' },
      -- Select keymaps
      s = { name = 'Select...' },
      -- Global operation keymaps
      g = { name = 'Global...' },
      -- Manage keymaps
      m = { name = 'Manage / Map...' },
      -- Jump keymaps
      j = { name = 'Jump...' },
      -- View keymaps
      v = { name = 'View...' },
      -- Tree keymaps
      t = { name = 'Tree...' },
      -- Option keymaps
      o = { name = 'Options...' },
    }, { prefix = '<leader>' })
  end,
}
