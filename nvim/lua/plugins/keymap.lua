-- Make Esc hide search highlight in normal mode
vim.api.nvim_set_keymap('n', '<Esc>', ':noh<CR>', { noremap = true, silent = true })
return {
  'mrjones2014/legendary.nvim',
  priority = 10000,
  lazy = false,
  dependencies = {
    'folke/which-key.nvim',
  },
  config = function()
    local wk = require('which-key')
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
            require('fzf-lua').files({
              fd_opts = '--no-ignore --hidden',
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
            require('fzf-lua').buffers({
              winopts = {
                width = 0.5,
                height = 0.5,
                preview = {
                  layout = 'vertical',
                  vertical = 'up',
                },
              },
            })
          end,
          description = 'Switch buffers',
        },
        {
          '<S-Tab>',
          ':tabnext<CR>',
          description = 'Switch tabs',
        },
        {
          '<Leader>fh',
          require('fzf-lua').help_tags,
          description = 'Find help',
        },
        {
          '<Leader>fs',
          require('fzf-lua').lsp_document_symbols,
          description = 'Find symbol in buffer',
        },
        {
          '<Leader>fS',
          require('fzf-lua').lsp_live_workspace_symbols,
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
          require('fzf-lua').lgrep_curbuf,
          description = 'Find text in buffer',
        },
        {
          '<Leader>fc',
          require('fzf-lua').registers,
          description = 'Find in clipboard (registers)',
        },
        {
          '<Leader>fi',
          require('fzf-lua').lsp_implementations,
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
          '<Leader>fu',
          function()
            require('fzf-lua').changes()
          end,
          description = 'Find in undo history',
        },
        -- Select keymaps
        {
          '<Leader>ss',
          function()
            require('fzf-lua').spell_suggest({
              winopts = {
                height = 11,
                width = 0.25,
                relative = 'cursor',
                row = -13,
                col = 1,
              },
            })
          end,
          description = 'Select spelling',
        },
        {
          '<Leader>sl',
          function()
            require('fzf-lua').filetypes({
              winopts = {
                height = 0.4,
                width = 0.4,
              },
            })
          end,
          description = 'Select language',
        },
        {
          '<Leader>sb',
          function()
            require('fzf-lua').git_branches()
          end,
          description = 'Select branch',
        },
        {
          '<Leader>sc',
          function()
            require('fzf-lua').colorschemes({
              winopts = {
                width = 0.3,
                height = 0.3,
                row = 0.9,
                col = 0.9,
              },
            })
          end,
          description = 'Select temporary colorscheme',
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
          '<Leader>jJ',
          ':Portal jumplist backward<CR>',
          description = 'Jump backward in place history',
        },
        {
          '<Leader>jK',
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
          description = 'Toggle tree explorer ',
        },
        {
          '<Leader>ef',
          ':Neotree focus<CR>',
          description = 'Focus tree explorer',
        },
        {
          '<Leader>ej',
          ':Neotree reveal<CR>',
          description = 'Jump to current buffer in tree explorer',
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
        -- Search and replace keybinds
        {
          '<Leader>rr',
          {
            n = ':SearchReplaceSingleBufferCWord<CR>',
            v = '"sy:%s/<C-r>s//gc<left><left><left>',
          },
          description = 'Search and replace selected',
        },
        {
          '<Leader>rs',
          ':SearchReplaceSingleBufferOpen<CR>',
          description = 'Search and replace...',
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
          ':BufDel<CR>',
          description = 'Close buffer',
        },
        {
          '<Leader>wQ',
          ':BufDel!<CR>',
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
          '<Leader>wr',
          ':LualineTabRename ',
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
          description = 'Toggle Trouble view',
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
          function()
            if vim.v.count then
              vim.api.nvim_feedkeys('gj', 'm', false)
            else
              vim.api.nvim_feedkeys('j', 'm', false)
            end
          end,
          { 'n', 'x' },
          description = 'Down visible line',
        },
        {
          'k',
          function()
            if vim.v.count then
              vim.api.nvim_feedkeys('gk', 'm', false)
            else
              vim.api.nvim_feedkeys('k', 'm', false)
            end
          end,
          { 'n', 'x' },
          description = 'Up visible line',
        },
        {
          'D',
          function()
            local opts = {
              focusable = false,
              close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
              border = 'none',
              source = 'always',
              prefix = ' ',
              scope = 'cursor',
            }
            vim.diagnostic.open_float(nil, opts)
          end,
        },
        {
          '<Leader>sd',
          function()
            if vim.o.background == 'dark' then
              vim.o.background = 'light'
            else
              vim.o.background = 'dark'
            end
          end,
          description = 'Set dark or light mode',
        },
        {
          'gm',
          '%',
          mode = { 'n', 'v', 'o' },
          description = 'Go to match',
        },
        {
          '<Leader>er',
          ':Hypersonic<CR>',
          mode = { 'n', 'v' },
          description = 'Explain selected regex'
        }
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
          mode = { 'n', 'v', 'o' },
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
          mode = { 'n', 'v', 'o' },
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
      commands = {},
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
        {
          { 'CursorHold', 'CursorHoldI', 'BufEnter', 'FocusGained' },
          ':checktime',
          description = 'Check for file changes periodically',
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
      -- Search and Replace keymaps
      r = { name = 'Replace...' },
    }, { prefix = '<Leader>' })
  end,
}
