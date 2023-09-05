local util = require('util')
return {
  -- {
  --   'nvim-telescope/telescope.nvim',
  --   branch = '0.1.x',
  --   dependencies = {
  --     { 'nvim-lua/plenary.nvim' },
  --     { 'nvim-telescope/telescope-live-grep-args.nvim' }, -- ripgrep args
  --     { 'stevearc/dressing.nvim' }, -- better UI for a few things
  --     { 'LukasPietzschmann/telescope-tabs' },
  --   },
  --   config = function()
  --     local telescope = require('telescope')
  --     local actions = require('telescope.actions')
  --     telescope.setup({
  --       border = {},
  --       pickers = {
  --         colorscheme = {
  --           enable_preview = true,
  --         },
  --         buffers = {
  --           mappings = {
  --             i = {
  --               ['<Esc>'] = actions.close,
  --               ['<tab>'] = 'select_default',
  --             },
  --           },
  --         },
  --       },
  --       extensions = {
  --         live_grep_args = {
  --           auto_quoting = true,
  --         },
  --       },
  --     })
  --     telescope.load_extension('live_grep_args')
  --     -- Set up dressing (ui enhancements)
  --     require('dressing').setup({
  --       input = {
  --         border = 'none',
  --       },
  --       select = {
  --         enabled = true,
  --         backend = { 'fzf_lua', 'telescope', 'builtin', 'nui' },
  --         fzf_lua = {
  --           winopts = {
  --             height = 0.5,
  --             width = 0.5,
  --           },
  --         },
  --       },
  --     })
  --   end,
  -- },
  -- {
  --   'debugloop/telescope-undo.nvim',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     'debugloop/telescope-undo.nvim',
  --   },
  --   config = function()
  --     require('telescope').load_extension('undo')
  --   end,
  -- },
  {
    'ibhagwan/fzf-lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local actions = require('fzf-lua.actions')
      require('fzf-lua').setup({
        winopts = {
          win_border = 'single',
        },
        actions = {
          buffers = {
            ['tab'] = actions.file_edit,
            ['default'] = actions.file_edit,
          },
        },
        fzf_opts = {
          ['--layout'] = 'default',
        },
        buffers = {
          ignore_current_buffer = true,
        },
      })
      require('fzf-lua').register_ui_select(function(_, items)
        local min_h, max_h = 0.15, 0.7
        local h = #items / vim.o.lines
        if h < min_h then
          h = min_h
        elseif h > max_h then
          h = max_h
        end
        return {
          winopts = {
            row = 0.6,
            col = 0.5,
            height = h,
            width = 0.4,
            relative = 'editor',
          },
        }
      end)
      util.keymap('n', '<Leader><Tab>', function()
        require('fzf-lua').files({
          fd_opts = '--no-ignore --hidden --type f' .. require('filter').formatFilter('fd'),
        })
      end, { desc = 'Find file' })
      util.keymap('n', '<Tab>', function()
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
      end, { desc = 'Switch buffers' })
      util.keymap('n', '<Leader>fh', require('fzf-lua').help_tags, { desc = 'Find help' })
      util.keymap('n', '<Leader>fs', require('fzf-lua').lsp_document_symbols, { desc = 'Find symbol in buffer' })
      util.keymap(
        'n',
        '<Leader>fS',
        require('fzf-lua').lsp_live_workspace_symbols,
        { desc = 'Find symbol in workspace' }
      )
      util.keymap('n', '<Leader>fb', require('fzf-lua').lgrep_curbuf, { desc = 'Find text in buffer' })
      util.keymap('n', '<Leader>fc', require('fzf-lua').registers, { desc = 'Find in clipboard (registers)' })
      util.keymap('n', '<Leader>fi', require('fzf-lua').lsp_implementations, { desc = 'Find implementations' })
      util.keymap('n', '<Leader>fu', function()
        require('fzf-lua').changes()
      end, { desc = 'Find in undo history' })
      -- Select keymaps
      util.keymap('n', '<Leader>ss', function()
        require('fzf-lua').spell_suggest({
          winopts = {
            height = 11,
            width = 0.25,
            relative = 'cursor',
            row = -13,
            col = 1,
          },
        })
      end, { desc = 'Select spelling' })
      util.keymap('n', '<Leader>sl', function()
        require('fzf-lua').filetypes({
          winopts = {
            height = 0.4,
            width = 0.4,
          },
        })
      end, { desc = 'Select language' })
      util.keymap('n', '<Leader>sb', function()
        require('fzf-lua').git_branches()
      end, { desc = 'Select branch' })
      util.keymap('n', '<Leader>sc', function()
        require('fzf-lua').colorschemes({
          winopts = {
            width = 0.3,
            height = 0.3,
            row = 0.9,
            col = 0.9,
          },
        })
      end, { desc = 'Select temporary colorscheme' })
      util.keymap('n', 'ga', function()
        require('fzf-lua').lsp_code_actions({
          winopts = {
            height = 11,
            width = 0.25,
            relative = 'cursor',
            row = -13,
            col = 1,
          },
          -- Temporary fix, fzf-lua overrides register_ui_select options after code actions call
          require('fzf-lua').register_ui_select(function(_, items)
            local min_h, max_h = 0.15, 0.7
            local h = #items / vim.o.lines
            if h < min_h then
              h = min_h
            elseif h > max_h then
              h = max_h
            end
            return {
              winopts = {
                row = 0.6,
                height = h,
                width = 0.4,
                relative = 'editor',
              },
            }
          end),
        })
      end, { desc = 'view code actions' })
    end,
  },
}
