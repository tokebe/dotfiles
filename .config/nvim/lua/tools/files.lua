local util = require('util')
return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      vim.g.neo_tree_remove_legacy_commands = 1

      require('neo-tree').setup({
        open_files_do_not_replace_types = { 'terminal', 'Trouble', 'toggleterm', 'qf', 'edgy' },
        add_blank_line_at_top = false,
        popup_border_style = 'NC',
        sources = {
          'filesystem',
          'buffers',
          'git_status',
          'document_symbols',
        },
        source_selector = {
          winbar = true,
          sources = {
            { source = 'filesystem' },
            { source = 'buffers' },
            { source = 'git_status' },
            { source = 'document_symbols' },
          },
        },
        window = {
          position = 'right',
        },
        filesystem = {
          filtered_items = {
            visible = true,
          },
          hijack_netrw_behavior = 'disabled',
        },
        default_component_configs = {
          icon = {
            folder_empty = '󰉖 ',
            folder_empty_open = '󰷏 ',
          },
          indent = {
            -- with_expanders = true,
          },
          modified = {
            symbol = '󰏫 ',
          },
          name = {
            highlight_opened_files = true,
          },
          git_status = {
            symbols = {
              -- Change type
              added = ' ',
              deleted = ' ',
              modified = '',
              renamed = '',
              -- Status type
              untracked = '',
              ignored = ' ',
              unstaged = '󰄱 ',
              staged = '󰄵 ',
              conflict = '󰃸 ',
            },
          },
        },
      })
    end,
    keys = {
      {
        '<Leader>ee',
        '<CMD>Neotree toggle<CR>',
        desc = 'Toggle tree explorer ',
      },
      {
        '<Leader>ef',
        '<CMD>Neotree focus<CR>',
        desc = 'Focus tree explorer',
      },
      {
        '<Leader>ej',
        '<CMD>Neotree reveal<CR>',
        desc = 'Jump to current buffer in tree explorer',
      },
      {
        '<Leader>eb',
        '<CMD>Neotree buffers<CR>',
        desc = 'View buffers explorer sidebar',
      },
      {
        '<Leader>es',
        '<CMD>Neotree document_symbols<CR>',
        desc = 'View symbols explorer sidebar',
      },
    },
  },
  -- { -- causes persistent dimming
  --   'lmburns/lf.nvim',
  --   dependencies = { 'akinsho/toggleterm.nvim' },
  --   config = function()
  --     require('lf').setup({
  --       border = 'single',
  --       default_file_manager = true,
  --       highlights = {
  --         Normal = { link = 'Normal' },
  --         NormalFloat = { link = 'Normal' },
  --         FloatBorder = { link = 'Normal' },
  --       },
  --     })
  --
  --     vim.keymap.set('n', '<Leader>mf', function()
  --       local path = vim.api.nvim_buf_get_name(0)
  --       if path == nil then
  --         path = vim.fn.getcwd()
  --       end
  --       require('lf').start()
  --     end, { desc = 'Manage Files with lf' })
  --   end,
  -- },
  {
    {
      'stevearc/oil.nvim',
      ---@module 'oil'
      ---@type oil.SetupOpts
      opts = {
        default_file_explorer = true,
        delete_to_trash = true,
        watch_for_changes = true,
        view_options = {
          show_hidden = true,
        },
        float = {
          max_width = 0.7,
          max_height = 0.7,
          border = 'single',
        },
        confirmation = {
          border = 'single',
        },
        use_default_keymaps = true,
        keymaps = {
          ['q'] = { 'actions.close', mode = 'n' },
          ['<CR>'] = 'actions.select',
          ['L'] = { 'actions.select', mode = 'n' },
          ['H'] = { 'actions.parent', mode = 'n' },
          ['<C-s>'] = { '<CMD>w<CR>' },
          ['Q'] = { '<CMD>q!<CR>' },
        },
      },
      -- Optional dependencies
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
      lazy = false,
      keys = {
        {
          '<Leader>mf',
          '<CMD>Oil --float --preview<CR>',
          desc = 'Manage Files with Oil',
        },
      },
    },
  },
  { 'malewicz1337/oil-git.nvim', dependencies = { 'stevearc/oil.nvim' } },
  {
    'JezerM/oil-lsp-diagnostics.nvim',
    dependencies = { 'stevearc/oil.nvim' },
    config = function()
      require('oil-lsp-diagnostics').setup({
        diagnostic_symbols = {
          error = ' ',
          warn = ' ',
          info = ' ',
          hint = '󱉵 ',
        },
      })
    end,
  },
}
