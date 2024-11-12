return {
  {
    -- Visual forward/backward jump in cursor location history
    'cbochs/portal.nvim',
    dependencies = {
      'cbochs/grapple.nvim',
      'ThePrimeagen/harpoon',
    },
    config = function()
      vim.api.nvim_set_hl(0, 'PortalLabel', { link = 'Normal' })
      vim.api.nvim_set_hl(0, 'PortalTitle', { link = 'Normal' })
      vim.api.nvim_set_hl(0, 'PortalBorder', { link = 'Normal' })
      vim.api.nvim_set_hl(0, 'PortalNormal', { link = 'Normal' })
    end,
    keys = {

      {
        '<Leader>jj',
        ':Portal jumplist backward<CR>',
        desc = 'Jump backward in place history',
      },
      {
        '<Leader>jk',
        ':Portal jumplist forward<CR>',
        desc = 'Jump forward in place history',
      },
    },
  },
}
