-- Make Esc hide search highlight in normal mode
vim.api.nvim_set_keymap('n', '<Esc>', ':noh<CR>', { noremap = true, silent = true })
return {
  'mrjones2014/legendary.nvim',
  dependencies = {
    'folke/which-key.nvim',
    'gnikdroy/projections.nvim',
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
        {
          '<leader>fp',
          function()
            require('codewindow').close_minimap() -- hide codewindow to avoid errors
            telescope.extensions.projections.projections()
          end,
          description = 'Find project',
        },
        {
          '<leader>fu',
          function()
            telescope.extensions.undo.undo()
          end,
          description = 'Find in undo history',
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
        {
          '<leader>gq',
          vim.lsp.buf.code_action,
          description = 'Quickfix...',
        },
        -- Jump kebinds
        {
          '<leader>jj',
          ':Portal jumplist backward<CR>',
          description = 'Jump backward in place history',
        },
        {
          '<leader>jk',
          ':Portal jumplist forward<CR>',
          description = 'Jump forward in place history',
        },
        -- Manage	keybinds
        {
          '<leader>ms',
          ':Navbuddy<CR>',
          description = 'Manage symbols with Navbuddy',
        },
        {
          '<leader>mr',
          ':RnvimrToggle<CR>',
          description = 'Toggle Ranger',
        },
        -- Tree keybinds
        {
          '<leader>ee',
          ':NvimTreeToggle<CR>',
          description = 'Toggle tree',
        },
        {
          '<leader>ef',
          ':NvimTreeFocus<CR>',
          description = 'Focus tree',
        },
        {
          '<leader>ej',
          ':NvimTreeFindFile<CR>',
          description = 'Jump to current buffer in tree',
        },
        {
          '<leader>ec',
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
          '<leader>ww',
          ':BufferClose<CR>',
          description = 'Close buffer',
        },
        {
          '<leader>qq',
          ':qa<CR>',
          description = 'Close NVIM',
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
      commands = {
        {
          ':AddWorkspace',
          function()
            require('projections.workspace').add(vim.loop.cwd())
          end,
          description = 'Add current directory as a workspace',
        },
      },
      funcs = {},
      autocmds = {
        {
          'QuitPre',
          function()
            vim.cmd('NvimTreeClose')
          end,
          description = 'Close nvim-tree before quit so nvim actually quits',
        },
        {
          'VimLeavePre',
          function()
            vim.opt.sessionoptions:append('localoptions')
            require('projections.session').store(vim.loop.cwd())
          end,
          description = 'Store session on exit',
        },
        {
          'VimEnter',
          function()
            if vim.fn.argc() == 0 then
              require('projections.switcher').switch(vim.loop.cwd())
            end
          end,
          description = 'Switch to project if nvim was started in a project dir',
        },
        {
          'DirChanged',
          function()
            if vim.fn.argc() == 0 then
              require('projections.switcher').switch(vim.loop.cwd())
            end
          end,
          description = 'Switch to project if nvim CDs into project',
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
      e = { name = 'Tree...' },
      -- Option keymaps
      o = { name = 'Options...' },
    }, { prefix = '<leader>' })
  end,
}
