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

      -- Diagnostic signs
      vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
      vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
      vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
      vim.fn.sign_define('DiagnosticSignHint', { text = '󱉵 ', texthl = 'DiagnosticSignHint' })

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
        },
        default_component_configs = {
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
}