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
}
