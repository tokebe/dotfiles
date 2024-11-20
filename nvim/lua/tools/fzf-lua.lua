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
        files = {
          previewer = 'bat',
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
      vim.keymap.set('n', '<Leader><Tab>', function()
        require('fzf-lua').files({
          cmd = "rg --files --color=never --no-ignore --hidden --glob '" .. require('filter').getFilter() .. "'",
          winopts = {
            preview = {
              layout = 'vertical',
              vertical = 'up',
            },
          },
        })
      end, { desc = 'Find file' })
      -- vim.keymap.set('n', '<Tab>', function()
      --   require('fzf-lua').buffers({
      --     winopts = {
      --       width = 0.5,
      --       height = 0.5,
      --       preview = {
      --         layout = 'vertical',
      --         vertical = 'up',
      --       },
      --     },
      --   })
      -- end, { desc = 'Switch buffers' })
      vim.keymap.set('n', '<Leader>fh', require('fzf-lua').help_tags, { desc = 'Find help' })
      vim.keymap.set(
        'n',
        '<Leader>fS',
        require('fzf-lua').lsp_live_workspace_symbols,
        { desc = 'Find symbol in workspace' }
      )
      vim.keymap.set('n', '<Leader>fb', function()
        require('fzf-lua').lgrep_curbuf({ winopts = { preview = { layout = 'vertical', vertical = 'up' } } })
      end, { desc = 'Find text in buffer' })
      vim.keymap.set('n', '<Leader>sr', require('fzf-lua').registers, { desc = 'Select from registers' })
      -- vim.keymap.set('n', '<Leader>fi', require('fzf-lua').lsp_implementations, { desc = 'Find implementations' })
      vim.keymap.set('n', '<Leader>fu', function()
        require('fzf-lua').changes()
      end, { desc = 'Find in undo history' })
      -- Select keymaps
      vim.keymap.set('n', '<Leader>ss', function()
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
      vim.keymap.set('n', '<Leader>sl', function()
        require('fzf-lua').filetypes({
          winopts = {
            row = 0.9,
            col = 0.9,
            height = 0.3,
            width = 0.3,
          },
        })
      end, { desc = 'Select language' })
      vim.keymap.set('n', '<Leader>sb', function()
        require('fzf-lua').git_branches()
      end, { desc = 'Select branch' })
      vim.keymap.set('n', '<Leader>sc', function()
        require('fzf-lua').colorschemes({
          winopts = {
            width = 0.3,
            height = 0.3,
            row = 0.9,
            col = 0.9,
          },
        })
      end, { desc = 'Select colorscheme' })
      vim.keymap.set('n', 'ga', function()
        require('fzf-lua').lsp_code_actions({
          -- previewer = 'codeaction_native',
          winopts = {
            height = 11,
            width = 0.75,
            relative = 'cursor',
            row = -13,
            col = 1,
            preview = {
              layout = 'flex',
              -- vertical = 'up',
            },
          },
          -- Temporary fix, fzf-lua overrides register_ui_select options after code actions call
          -- require('fzf-lua').register_ui_select(function(_, items)
          --   local min_h, max_h = 0.15, 0.7
          --   local h = #items / vim.o.lines
          --   if h < min_h then
          --     h = min_h
          --   elseif h > max_h then
          --     h = max_h
          --   end
          --   return {
          --     winopts = {
          --       row = 0.6,
          --       height = h,
          --       width = 0.4,
          --       relative = 'editor',
          --     },
          --   }
          -- end),
        })
      end, { desc = 'view code actions' })
      vim.keymap.set('n', '<Leader><Leader>', function()
        require('fzf-lua').keymaps({
          previewer = 'none',
          winopts = {
              height = 0.3,
              width = 0.9,
              row = 0.9,
          }
        })
      end, { desc = 'Search keymaps' })
    end,
  },
}
