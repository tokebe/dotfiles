return { -- Visual forward/backward jump in cursor location history
  'cbochs/portal.nvim',
  dependencies = {
    "cbochs/grapple.nvim",
    "ThePrimeagen/harpoon",
  },
  config = function ()
    vim.keymap.set("n", "<Leader>o", "<cmd>Portal jumplist backward<CR>")
    vim.keymap.set("n", "<Leader>i", "<cmd>Portal jumplist forward<CR>")
  end
}
