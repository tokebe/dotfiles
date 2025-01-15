return {
  { -- Turbocharged jump-by-type
    'ggandor/leap.nvim',
    lazy = false,
    dependencies = {
      'tpope/vim-repeat',
    },
    config = function()
      require('leap').setup({})
      require('leap.user').set_repeat_keys('<enter>', '<backspace>')
      vim.keymap.set({ 'n', 'x', 'o' }, 'gA', function()
        require('leap.treesitter').select()
      end)

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
      highlight = true,
    },
    cmd = 'Treewalker',
    keys = {
      { '<M-J>', ':Treewalker Down<CR>', mode = 'n', noremap = true },
      { '<M-K>', ':Treewalker Up<CR>', mode = 'n', noremap = true },
      { '<M-H>', ':Treewalker Left<CR>', mode = 'n', noremap = true },
      { '<M-L>', ':Treewalker Right<CR>', mode = 'n', noremap = true },
      { '<Leader>mj', ':Treewalker SwapDown<CR>', mode = 'n', noremap = true },
      { '<M-K>mk', ':Treewalker SwapUp<CR>', mode = 'n', noremap = true },
      { '<M-H>mh', ':Treewalker SwapLeft<CR>', mode = 'n', noremap = true },
      { '<M-L>ml', ':Treewalker SwapRight<CR>', mode = 'n', noremap = true },
    },
  },
}
