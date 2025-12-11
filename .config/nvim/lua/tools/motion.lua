return {
  { -- Turbocharged jump-by-type
    'https://codeberg.org/andyg/leap.nvim',
    lazy = false,
    dependencies = {
      'tpope/vim-repeat',
    },
    config = function()
      require('leap').setup({})
      require('leap.user').set_repeat_keys('<enter>', '<backspace>')

      vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
      vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')

      vim.keymap.set({ 'n', 'x', 'o' }, 'gA', function()
        require('leap.treesitter').select()
      end)

      vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
      -- Exclude whitespace and the middle of alphabetic words from preview:
      --   foobar[baaz] = quux
      --   ^----^^^--^^-^-^--^
      require('leap').opts.preview_filter = function(ch0, ch1, ch2)
        return not (ch1:match('%s') or ch0:match('%a') and ch1:match('%a') and ch2:match('%a'))
      end

      -- Linewise.
      vim.keymap.set({ 'n', 'x', 'o' }, 'ga', 'V<cmd>lua require("leap.treesitter").select()<cr>')
    end,
  },
  {
    'aaronik/treewalker.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      highlight = false,
      highlight_duration = 100,
    },
    cmd = 'Treewalker',
    keys = {
      { '<M-J>', '<CMD>Treewalker Down<CR>', mode = 'n', noremap = true, silent = true },
      { '<M-K>', '<CMD>Treewalker Up<CR>', mode = 'n', noremap = true, silent = true },
      { '<M-H>', '<CMD>Treewalker Left<CR>', mode = 'n', noremap = true, silent = true },
      { '<M-L>', '<CMD>Treewalker Right<CR>', mode = 'n', noremap = true, silent = true },
      { '<Leader>mj', '<CMD>Treewalker SwapDown<CR>', mode = 'n', noremap = true, silent = true },
      { '<M-K>mk', '<CMD>Treewalker SwapUp<CR>', mode = 'n', noremap = true, silent = true },
      { '<M-H>mh', '<CMD>Treewalker SwapLeft<CR>', mode = 'n', noremap = true, silent = true },
      { '<M-L>ml', '<CMD>Treewalker SwapRight<CR>', mode = 'n', noremap = true, silent = true },
    },
  },
}
