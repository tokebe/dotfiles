return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    require('nvim-tree').setup({
      hijack_cursor = true,
      sync_root_with_cwd = true,
      reload_on_bufenter = true,
      update_focused_file = {
        enable = true,
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
      },
      modified = {
        enable = true,
      },
      select_prompts = true,
      view = {
        side = 'right',
      },
      renderer = {
        group_empty = true,
        highlight_git = true,
        highlight_opened_files = 'all',
        highlight_modified = 'all',
        indent_markers = {
          enable = true,
        },
      },
      actions = {
        change_dir = {
          enable = false,
        },
      },
      experimental = {
        git = {
          async = true,
        },
      },
    })
  end
}
