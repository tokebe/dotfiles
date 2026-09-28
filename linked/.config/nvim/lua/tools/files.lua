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
  -- {
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
  --     vim.keymap.set('n', '<Leader>mF', function()
  --       local path = vim.api.nvim_buf_get_name(0)
  --       if path == nil then
  --         path = vim.fn.getcwd()
  --       end
  --       require('lf').start()
  --     end, { desc = 'Manage Files with lf' })
  --   end,
  -- },
  {
    'mikavilpas/yazi.nvim',
    version = '*', -- use the latest stable version
    event = 'VeryLazy',
    dependencies = {
      { 'nvim-lua/plenary.nvim', lazy = true },
    },
    keys = {
      {
        '<leader>mf',
        mode = { 'n', 'v' },
        '<cmd>Yazi<cr>',
        desc = 'Manage files with yazi',
      },
    },
    opts = {
      floating_window_scaling_factor = 0.75,
      yazi_floating_window_winblend = 10,
      highlight_hovered_buffers_in_same_directory = false,
      highlight_groups = {
        -- Make hovered buffer highlight not actually change
        hovered_buffer = { link = 'Normal' },
      },
      yazi_floating_window_border = 'single',
    },
  },
}
