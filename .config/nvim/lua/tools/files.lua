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
        add_blank_line_at_top = true,
        popup_border_style = 'NC',
        sources = {
          'filesystem',
          'buffers',
          'git_status',
          'document_symbols',
        },
        source_selector = {
          winbar = true,
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
        ':Neotree toggle<CR>',
        desc = 'Toggle tree explorer ',
      },
      {
        '<Leader>ef',
        ':Neotree focus<CR>',
        desc = 'Focus tree explorer',
      },
      {
        '<Leader>ej',
        ':Neotree reveal<CR>',
        desc = 'Jump to current buffer in tree explorer',
      },
    },
  },
  {
    'lmburns/lf.nvim',
    dependencies = { 'akinsho/toggleterm.nvim' },
    config = function()
      require('lf').setup({
        border = 'single',
        default_file_manager = true,
        highlights = {
          Normal = { link = 'Normal' },
          NormalFloat = { link = 'Normal' },
          FloatBorder = { link = 'Normal' },
        },
      })

      vim.keymap.set('n', '<Leader>mf', function()
        local path = vim.api.nvim_buf_get_name(0)
        if path == nil then
          path = vim.fn.getcwd()
        end
        require('lf').start()
      end, { desc = 'Manage Files with lf' })
    end,
  },
}
