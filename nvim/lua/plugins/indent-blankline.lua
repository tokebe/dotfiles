return {
  -- Add indentation guides even on blank lines
  'lukas-reineke/indent-blankline.nvim',
  event = 'BufEnter',
  config = function()
    require('indent_blankline').setup({
      char = '│',
      show_trailing_blankline_indent = false,
      use_treesitter = true,
      -- use_treesitter_scope = true,
      show_current_context = true,
      show_current_context_start = true,
      filetype_exclude = require('config.filetype_excludes'),
    })
  end,
}
