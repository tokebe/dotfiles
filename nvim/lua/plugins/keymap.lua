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
    telescope.builtin = require('telescope.builtin')
    telescope.themes = require('telescope.themes')
    require('legendary').setup({
      keymaps = {
        -- Summon Command palette
        {
          '<Leader><Leader>',
          ':Legendary<CR>',
          description = 'Open command palette',
        },
        -- Find keymaps
        {
          '<Leader><Tab>',
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
          '<Leader><Tab>',
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
          '<Leader>fg',
          function()
            require('spectre').open()
          end,
          description = 'Find in files (grep)',
        },
        {
          '<Leader>ff',
          {
            n = function()
              require('spectre').open_visual({ select_word = true })
            end,
            v = function()
              require('spectre').open_visual()
            end,
          },
          description = 'Search word/selection in files',
        },
        {
          '<Tab>',
          function()
            telescope.builtin.buffers(telescope.themes.get_dropdown({
              sort_lastused = true,
              sort_mru = true,
              ignore_current_buffer = true,
              -- jump to file if only one, not great because you can get inintended input
              -- on_complete = {
              --   function(picker)
              --     -- if we have exactly one match, select it
              --     if picker.manager.linked_states.size == 1 then
              --       require('telescope.actions').select_default(picker.prompt_bufnr)
              --     end
              --   end,
              -- },
            }))
          end,
          description = 'Switch buffers',
        },
        {
          '<S-Tab>',
          ':tabnext<CR>',
          -- function ()
          --   require('telescope-tabs').list_tabs()
          -- end,
          description = 'Switch tabs',
        },
        {
          '<Leader>fh',
          telescope.builtin.help_tags,
          description = 'Find help',
        },
        {
          '<Leader>fs',
          telescope.builtin.lsp_document_symbols,
          description = 'Find symbol in buffer',
        },
        {
          '<Leader>fS',
          telescope.builtin.lsp_dynamic_workspace_symbols,
          description = 'Find symbol in workspace',
        },
        {
          '<Leader>fd',
          function()
            vim.cmd('Trouble document_diagnostics')
          end,
          description = 'Find diagnostics',
        },
        {
          '<Leader>fD',
          function()
            vim.cmd('Trouble workspace_diagnostics')
          end,
          description = 'Find workspace diagnostics',
        },
        {
          '<Leader>fb',
          telescope.builtin.current_buffer_fuzzy_find,
          description = 'Find text in buffer',
        },
        {
          '<Leader>fc',
          telescope.builtin.registers,
          description = 'Find in clipboard (registers)',
        },
        {
          '<Leader>fi',
          telescope.builtin.lsp_implementations,
          description = 'Find implementations',
        },
        {
          '<Leader>fq',
          function()
            vim.cmd('Trouble quickfix')
          end,
          description = 'Find quickfix',
        },
        {
          '<Leader>ft',
          function()
            vim.cmd('TodoTrouble')
          end,
          description = 'Find todos',
        },
        {
          '<Leader>fp',
          function()
            vim.cmd('SessionManager load_session')
          end,
          description = 'Find project',
        },
        {
          '<Leader>fu',
          function()
            telescope.extensions.undo.undo()
          end,
          description = 'Find in undo history',
        },
        -- Select keymaps
        {
          '<Leader>ss',
          function()
            telescope.builtin.spell_suggest(telescope.themes.get_cursor())
          end,
          description = 'Select spelling',
        },
        {
          '<Leader>sl',
          function()
            telescope.builtin.filetypes(telescope.themes.get_dropdown())
          end,
          description = 'Select language',
        },
        {
          '<Leader>sb',
          function()
            telescope.builtin.git_branches(telescope.themes.get_dropdown())
          end,
          description = 'Select branch',
        },
        {
          '<Leader>sc',
          function()
            telescope.builtin.colorscheme(telescope.themes.get_dropdown())
          end,
          description = 'Select temporary colorscheme',
        },
        {
          '<Leader>sC',
          require('colorscheme-persist').picker,
          description = 'Select default colorscheme',
        },
        -- Global operation keymaps
        {
          '<Leader>gf',
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
          '<Leader>gr',
          ':IncRename ' .. vim.fn.expand('<cword>'),
          description = 'Rename symbol',
          noremap = true,
        },
        {
          '<Leader>gR',
          function()
            require('ssr').open()
          end,
          mode = { 'n', 'x' },
          description = 'Structural replace',
        },
        {
          '<Leader>gq',
          vim.lsp.buf.code_action,
          description = 'Quickfix...',
        },
        -- Jump keybinds
        {
          '<Leader>jj',
          ':Portal jumplist backward<CR>',
          description = 'Jump backward in place history',
        },
        {
          '<Leader>jk',
          ':Portal jumplist forward<CR>',
          description = 'Jump forward in place history',
        },
        -- Manage keybinds
        {
          '<Leader>ms',
          ':Navbuddy<CR>',
          description = 'Manage symbols with Navbuddy',
        },
        {
          '<Leader>mf',
          ':RnvimrToggle<CR>',
          description = 'Toggle Ranger',
        },
        -- Tree keybinds
        {
          '<Leader>ee',
          ':Neotree toggle<CR>',
          description = 'Toggle tree',
        },
        {
          '<Leader>ef',
          ':Neotree focus<CR>',
          description = 'Focus tree',
        },
        {
          '<Leader>ej',
          ':Neotree reveal<CR>',
          description = 'Jump to current buffer in tree',
        },
        -- Option/toggle keybinds
        {
          '<Leader>oa',
          ':ASToggle<CR>',
          description = 'Toggle autosave',
        },
        {
          '<Leader>om',
          ':Mason<CR>',
          description = 'Manage LSPs with Mason',
        },
        {
          '<Leader>op',
          ':Lazy<CR>',
          description = 'Manage plugins with Lazy',
        },
        {
          '<Leader>ot',
          ':TransparentToggle<CR>',
          description = 'Toggle transparent background',
        },

        {
          '<Leader>od',
          function()
            require('toggle_lsp_diagnostics').toggle_virtual_text()
          end,
          description = 'Toggle LSP diagnostic text',
        },
        -- Buffer keybinds
        {
          '<lt>',
          ':bprev<CR>',
          description = 'Next buffer',
        },
        {
          '>',
          ':bnext<CR>',
          description = 'Previous buffer',
        },
        {
          '<A-lt>',
          ':tabprev<CR>',
          description = 'Previous Tabpage',
        },
        {
          '<A->>',
          ':tabnext<CR>',
          description = 'Next Tabpage',
        },
        -- Window keybinds
        {
          '<Leader>wq',
          ':bdelete<CR>',
          description = 'Close buffer',
        },
        {
          '<Leader>wQ',
          ':bdelete!<CR>',
          description = 'Close buffer (force)',
        },
        {
          '<Leader>wn',
          ':enew<CR>',
          description = 'New buffer',
        },
        {
          '<Leader>wt',
          ':tabnew<CR>',
          description = 'New tabpage',
        },
        {
          '<Leader>wc',
          ':tabclose<CR>',
          description = 'Close tabpage',
        },
        {
          '<Leader>wb',
          function()
            vim.cmd('TablineBuffersBind ' .. vim.api.nvim_buf_get_name(0))
          end,
          -- ':TablineBuffersBind '
          description = 'Bind current buffer to current tab',
        },
        {
          '<Leader>wu',
          ':TablineBuffersClearBind<CR>',
          description = 'Unbind all buffers from current tab',
        },
        {
          '<Leader>wr',
          ':TablineTabRename ',
          description = 'Rename current tabpage',
        },
        {
          '<Leader>ww',
          ':WindowsMaximize<CR>',
          description = 'Maximize current window',
        },
        {
          '<Leader>we',
          ':WindowsEqualize<CR>',
          description = 'Equalize windows',
        },
        {
          '<Leader>wa',
          ':WindowsToggleAutowidth<CR>',
          description = 'Toggle window autowidth',
        },
        {
          '<Leader>wh',
          ':WindowsMaximizeHorizontally<CR>',
          description = 'Maximize window horizontally',
        },
        {
          '<Leader>wv',
          ':WindowsMaximizeVertically<CR>',
          description = 'Maximize window vertically',
        },
        -- Terminal/Trouble Keybinds
        {
          '<Leader>tt',
          ':999ToggleTerm direction=float<CR>',
          description = 'Toggle dedicated floating terminal',
        },
        {
          '<Leader>ta',
          ':TroubleToggle<CR>',
          description = 'Toggle Trouble view'
        },
        -- Session keybinds
        {
          '<Leader>qq',
          ':qa<CR>',
          description = 'Close NVIM',
        },
        {
          '<Leader>qQ',
          ':qa!<CR>',
          description = 'Force close NVIM',
        },
        {
          '<Leader>qs',
          ':SessionManager save_current_session<CR>',
          description = 'Save current session',
        },
        -- Misc keybinds
        {
          'j',
          function ()
            if vim.v.count then
              vim.api.nvim_feedkeys('gj', 'm', false)
            else
              vim.api.nvim_feedkeys('j', 'm', false)
            end
          end,
          { 'n', 'x' },
        },
        {
          'k',
          function ()
            if vim.v.count then
              vim.api.nvim_feedkeys('gk', 'm', false)
            else
              vim.api.nvim_feedkeys('k', 'm', false)
            end
          end,
          { 'n', 'x' },
        },
        -- {
        --   -- Slightly smarter tab, would be better if it could be vscode-like
        --   '<Tab>',
        --   function()
        --     if string.len(vim.api.nvim_get_current_line()) == 0 then
        --       local key = vim.api.nvim_replace_termcodes('<C-f>', true, false, true)
        --       vim.api.nvim_feedkeys(key, 'n', false)
        --     else
        --       local key = vim.api.nvim_replace_termcodes('<Tab>', true, false, true)
        --       vim.api.nvim_feedkeys(key, 'm', false)
        --     end
        --   end,
        --   mode = { 'i' },
        --   description = 'Smarter tab',
        -- },
        {
          'H',
          function()
            local r, c = unpack(vim.api.nvim_win_get_cursor(0))
            local start, final, match = vim.api.nvim_get_current_line():find('%S')
            if c + 1 == start then
              vim.api.nvim_feedkeys('0', 'm', false)
            else
              vim.api.nvim_feedkeys('_', 'm', false)
            end
          end,
          description = 'Go to first char',
        },
        {
          'L',
          function()
            local r, c = unpack(vim.api.nvim_win_get_cursor(0))
            local start, final, match = vim.api.nvim_get_current_line():find('%S')
            if c + 1 == final then
              vim.api.nvim_feedkeys('g_', 'm', false)
            else
              vim.api.nvim_feedkeys('$', 'm', false)
            end
          end,
          description = 'Go to last char',
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
        -- LSP actions
        {
          'ga',
          function()
            require('actions-preview').code_actions()
          end,
          description = 'view code actions',
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
          'ModeChanged',
          function()
            if
              ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
              and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
              and not require('luasnip').session.jump_active
            then
              require('luasnip').unlink_current()
            end
          end,
          description = 'Prevent luasnip from jumping back after finishing a snippet',
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
      -- Terminal keymaps
      t = { name = 'Terminal...' },
      -- Option keymaps
      o = { name = 'Options...' },
    }, { prefix = '<Leader>' })
  end,
}
