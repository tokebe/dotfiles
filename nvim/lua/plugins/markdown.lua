return {
  {
    -- All-in-one markdown editing stuff
    'jakewvincent/mkdnflow.nvim',
    config = function()
      require('mkdnflow').setup({
        mappings = {
          MkdnNewListItem = { 'i', '<CR>' },
        },
      })
    end,
  },
  { -- Markdown preview, only good on non-windows
    'iamcco/markdown-preview.nvim',
  },
  {
    -- In-nvim preview
    'ellisonleao/glow.nvim',
    config = function()
      require('glow').setup({
        border = 'rounded',
        pager = false,
      })
    end,
  },
}
