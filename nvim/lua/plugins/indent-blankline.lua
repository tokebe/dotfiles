return {
  -- Add indentation guides even on blank lines
  'lukas-reineke/indent-blankline.nvim',
  -- Enable `lukas-reineke/indent-blankline.nvim`
  -- See `:help indent_blankline.txt`
  config = function()
    require('indent_blankline').setup({
      char = '│',
      show_trailing_blankline_indent = false,
      use_treesitter = true,
      use_treesitter_scope = true,
      show_current_context = true,
      show_current_context_start = true,
    })
  end
}
