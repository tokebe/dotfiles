return {
  {
    'saxon1964/neovim-tips',
    version = '*',
    lazy = false,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'MeanderingProgrammer/render-markdown.nvim',
    },
    opts = {
      bookmark_symbol = '  ',
    },
    init = function()
      -- OPTIONAL: Change to your liking or drop completely
      -- The plugin does not provide default key mappings, only commands
      vim.keymap.set('n', '<leader>nto', ':NeovimTips<CR>', { desc = 'Neovim tips', noremap = true, silent = true })
      vim.keymap.set(
        'n',
        '<leader>nte',
        ':NeovimTipsEdit<CR>',
        { desc = 'Edit your Neovim tips', noremap = true, silent = true }
      )
      vim.keymap.set(
        'n',
        '<leader>nta',
        ':NeovimTipsAdd<CR>',
        { desc = 'Add your Neovim tip', noremap = true, silent = true }
      )
      vim.keymap.set(
        'n',
        '<leader>ntr',
        ':NeovimTipsRandom<CR>',
        { desc = 'Show random tip', noremap = true, silent = true }
      )
    end,
  },
}
