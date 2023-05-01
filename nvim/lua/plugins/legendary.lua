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
    telescope.builtin = require('telescope.builtin')
    telescope.themes = require('telescope.themes')
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
            telescope.builtin.find_files({
              no_ignore = true,
              hidden = true,
              follow = true,
            })
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
          function()
            telescope.builtin.buffers(telescope.themes.get_dropdown({
              sort_lastused = true,
              sort_mru = true,
            }))
          end,
          description = 'Find open buffer',
        },
        {
          '<tab>',
          function()
            telescope.builtin.buffers(telescope.themes.get_dropdown({
              sort_lastused = true,
              sort_mru = true,
            }))
          end,
          description = 'Find open buffer',
        },
        {
          '<leader>fh',
          telescope.builtin.help_tags,
          description = 'Find help',
        },
        {
          '<leader>fs',
          telescope.builtin.lsp_document_symbols,
          description = 'Find symbol in buffer',
        },
        {
          '<leader>fS',
          telescope.builtin.lsp_dynamic_workspace_symbols,
          description = 'Find symbol in workspace',
        },
        {
          '<leader>fd',
          telescope.builtin.diagnostics,
          description = 'Find diagnostics',
        },
        {
          '<leader>fr',
          telescope.builtin.lsp_references,
          description = 'Find references',
        },
        {
          '<leader>ft',
          telescope.builtin.current_buffer_fuzzy_find,
          description = 'Find text in buffer',
        },
        {
          '<leader>fc',
          telescope.builtin.registers,
          description = 'Find in clipboard (registers)',
        },
        {
          '<leader>fi',
          telescope.builtin.lsp_implementations,
          description = 'Find implementations',
        },
        {
          '<leader>fq',
          telescope.builtin.quickfix,
          description = 'Find quickfix',
        },
        {
          '<leader>fp',
          function()
            -- require('codewindow').close_minimap() -- hide codewindow to avoid errors
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
          '<leader>ss',
          function()
            telescope.builtin.spell_suggest(telescope.themes.get_cursor())
          end,
          description = 'Select spelling',
        },
        {
          '<leader>sl',
          function()
            telescope.builtin.filetypes(telescope.themes.get_dropdown())
          end,
          description = 'Select language',
        },
        {
          '<leader>sb',
          function()
            telescope.builtin.git_branches(telescope.themes.get_dropdown())
          end,
          description = 'Select branch',
        },
        {
          '<leader>sc',
          function()
            telescope.builtin.colorscheme(telescope.themes.get_dropdown())
          end,
          description = 'Select temporary colorscheme',
        },
        {
          '<leader>sC',
          require('colorscheme-persist').picker,
          description = 'Select default colorscheme',
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
          description = 'Format file',
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
        -- Manage keybinds
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
        {
          '<leader>ot',
          ':TransparentToggle<CR>',
          description = 'Toggle transparent background',
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
