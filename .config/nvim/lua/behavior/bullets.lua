return {
  -- { -- Insert new bullets automatically
  --   'dkarter/bullets.vim',
  --   version = '^2.x.x',
  --   config = function()
  --     local g = vim.g
  --     g.bullets_enabled_file_types = {
  --       'markdown',
  --       'text',
  --       'gitcommit',
  --       'yaml',
  --       '',
  --     }
  --     g.bullets_set_mappings = 1
  --     g.bullets_delete_last_bullet_if_empty = 1
  --     g.bullets_pad_right = 0
  --     g.bullets_auto_indent_after_colon = 1
  --     g.bullets_renumber_on_change = 1
  --     g.bullets_nested_checkboxes = 1
  --     g.bullets_checkbox_markers = ' x'
  --   end,
  -- },
  {
    'gaoDean/autolist.nvim',
    ft = {
      'markdown',
      'text',
      'tex',
      'plaintex',
      'norg',
    },
    config = function()
      require('autolist').setup()
      vim.keymap.set('i', '<CR>', '<CR><cmd>AutolistNewBullet<cr>')
      vim.keymap.set('n', 'o', 'o<cmd>AutolistNewBullet<cr>')
      vim.keymap.set('n', 'O', 'O<cmd>AutolistNewBulletBefore<cr>')
      vim.keymap.set('n', '<CR>', '<cmd>AutolistToggleCheckbox<cr><CR>')
      vim.keymap.set('n', '<C-r>', '<cmd>AutolistRecalculate<cr>')
    end,
  },
}
