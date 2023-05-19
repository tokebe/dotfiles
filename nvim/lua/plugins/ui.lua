return {
  {
    'kosayoda/nvim-lightbulb',
    config = function()
      require('nvim-lightbulb').setup({
        sign = {
          enabled = false,
        },
        status_text = {
          enabled = true,
          text = '󱉵',
        },
        autocmd = {
          enabled = true,
        },
      })
    end,
  },
  {
    'petertriho/nvim-scrollbar',
    config = function()
      require('scrollbar').setup({
        excluded_filetypes = require('config.filetype_excludes'),
        marks = {
          Cursor = {
            text = '',
          },
        },
        handlers = {
          gitsigns = true,
          search = true,
        },
      })
    end,
  },
  {
    'folke/todo-comments.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('todo-comments').setup({
        highlight = {
          pattern = [[.*<(KEYWORDS)>\s*:?]],
        },
        search = {
          pattern = [[\b(KEYWORDS):?]],
        },
      })
    end,
  },
  {
    'WhoIsSethDaniel/toggle-lsp-diagnostics.nvim',
    config = function()
      require('toggle_lsp_diagnostics').init({
        underline = true,
        virtual_text = true,
        update_in_insert = false,
      })
    end,
  },
  {
    'zbirenbaum/neodim',
    event = 'LspAttach',
    config = function()
      require('neodim').setup({
        alpha = 0.75,
        blend_color = '#000000',
        update_in_insert = {
          enable = false,
          delay = 100,
        },
        hide = {
          virtual_text = true,
          signs = true,
          underline = true,
        },
      })
    end,
  },
  {
    'nanozuki/tabby.nvim',
    config = function()
      require('tabby.tabline').use_preset('active_wins_at_tail')
    end,
  },
  -- {
  --   'romgrk/barbar.nvim',
  --   dependencies = {
  --     'nvim-tree/nvim-web-devicons',
  --   },
  --   version = '^1.0.0',
  --   init = function()
  --     vim.g.barbar_auto_setup = false
  --   end,
  --   opts = {
  --     auto_hide = true,
  --   },
  -- },
  -- {
  --   'kdheepak/tabline.nvim',
  --   config = function()
  --     require('tabline').setup({
  --       enable = true,
  --       options = {
  --         modified_icon = '',
  --         modified_italic = true,
  --         section_separators = { '', '' },
  --         component_separators = { '╱', '╱' },
  --         show_filename_only = true,
  --         show_tabs_always = true,
  --       },
  --     })
  --   end,
  -- },
}
