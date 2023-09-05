return {
  {
    -- Visual forward/backward jump in cursor location history
    'cbochs/portal.nvim',
    dependencies = {
      'cbochs/grapple.nvim',
      'ThePrimeagen/harpoon',
    },
    config = function() end,
    keys = {

      {
        '<Leader>jJ',
        ':Portal jumplist backward<CR>',
        description = 'Jump backward in place history',
      },
      {
        '<Leader>jK',
        ':Portal jumplist forward<CR>',
        description = 'Jump forward in place history',
      },
    },
  },
}
