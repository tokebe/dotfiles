return {
  { -- underdot occurances of symbol
    'RRethy/vim-illuminate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('illuminate').configure({
        filetypes_denylist = require('config.filetype_excludes'),
        under_cursor = false,
      })
      vim.api.nvim_set_hl(0, 'IlluminatedWordText', { underdotted = true })
      vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { underdotted = true })
      vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { underdotted = true })
      local a = 0
      print(a)
    end,
  },
  { -- highlight occurances of word
    'echasnovski/mini.cursorword',
    config = function()
      require('mini.cursorword').setup()
    end,
  },
}
