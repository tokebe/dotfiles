local util = require('util')
return {
  'nvim-pack/nvim-spectre',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('spectre').setup({
      open_cmd = 'botright vnew',
      -- TODO add binding in keymap.lua
      color_devicons = true,
      live_update = true,
      line_sep_start = '┌-----------------------------------------',
      result_padding = '┆  ',
      line_sep = '└-----------------------------------------',
      highlight = {
        search = 'DiffAdd',
        replace = 'DiffDelete',
        -- search = 'IncSearch',
        -- replace = 'IncSearch',
      },
      mapping = {
        ['toggle_gitignore'] = {
          map = 'tg',
          cmd = '<cmd>lua require("spectre").change_options("gitignore")<CR>',
          desc = 'toggle respect .gitignore',
        },
      },
      find_engine = {
        ['rg'] = {
          cmd = 'rg',
          options = {
            ['gitignore'] = {
              value = '--no-ignore',
              icon = '[G]',
              desc = 'respect .gitignore',
            },
          },
        },
      },
      default = {
        find = {
          options = { 'ignore-case', 'gitignore', 'hidden' },
        },
      },
    })
    util.keymap('n', '<Leader>ff', function()
      require('spectre').open_visual({
        path = string.format(
          '!{%s}',
          table.concat(vim.split(require('filter').formatFilter(), '\n', { plain = true }), ',')
        ),
      })
    end, { desc = 'Search word/selection in files' })

    util.keymap('v', '<Leader>ff', function()
      require('spectre').open_visual({
        path = string.format(
          '!{%s}',
          table.concat(vim.split(require('filter').formatFilter(), '\n', { plain = true }), ',')
        ),
        select_word = true,
      })
    end, { desc = 'Search word/selection in files' })
  end,
}