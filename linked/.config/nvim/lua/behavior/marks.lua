return {
  { -- Add marks to sign column and some other fancy behavior
    'chentoast/marks.nvim',
    config = function()
      require('marks').setup()
    end,
  },
}
