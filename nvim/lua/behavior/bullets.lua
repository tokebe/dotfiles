return {
  { -- Insert new bullets automatically
    'dkarter/bullets.vim',
    config = function()
      local g = vim.g
      g.bullets_enabled_file_types = {
        'markdown',
        'text',
        'gitcommit',
        'yaml',
        '',
      }
      g.bullets_set_mappings = 1
      g.bullets_delete_last_bullet_if_empty = 1
      g.bullets_pad_right = 0
      g.bullets_auto_indent_after_colon = 1
      g.bullets_renumber_on_change = 1
      g.bullets_nested_checkboxes = 1
      g.bullets_checkbox_markers = ' x'
    end,
  },
}
