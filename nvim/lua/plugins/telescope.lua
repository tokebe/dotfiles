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
            height = h,
            width = 0.4,
            relative = 'editor'
          },
        }
      end)
    end,
  },
}
