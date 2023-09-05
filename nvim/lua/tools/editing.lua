local util = require('util')
return {
  { -- quick selection by syntax node
    'sustech-data/wildfire.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('wildfire').setup()
    end,
  },
  { -- Automatic block split/join
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({
        use_default_keymaps = false,
      })
      util.keymap('n', '<Leader>gs', ':TSJToggle<CR>', { desc = 'Split/join block using Treesitter' })
    end,
  },
  { -- Intelligent increment/decrement, with cycles for bools/etc.
    'nat-418/boole.nvim',
    config = function()
      require('boole').setup({
        mappings = {
          increment = '<C-a>',
          decrement = '<C-x>',
        },
        additions = {},
        allow_caps_additions = {},
        -- NOTE: can add `additions` and `allow_caps_additions`
        -- these allow new cycles, and case-insenstive, case-aware cycles
      })
    end,
  },
  { -- Automatic comment/uncomment lines
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  },
  {
    'roobert/search-replace.nvim',
    config = function()
      require('search-replace').setup({})
      util.keymap('n', '<Leader>rr', '<CMD>SearchReplaceSingleBufferCWord<CR>', {
        desc = 'Search and replace selected',
      })
      util.keymap('v', '<Leader>rr', '"sy:%s/<C-r>s//gc<left><left><left>', {
        desc = 'Search and replace selected',
      })
      util.keymap('n', '<Leader>rs', function()
        vim.cmd('SearchReplaceSingleBufferOpen')
      end, {
        desc = 'Search and replace...',
      })
    end,
  },
  {
    'kylechui/nvim-surround',
    version = '*',
    config = function()
      require('nvim-surround').setup({})
    end,
  },
  {
    'roobert/surround-ui.nvim',
    dependencies = { 'kylechui/nvim-surround', 'folke/which-key.nvim' },
    config = function()
      require('surround-ui').setup({
        root_key = 'S',
      })
    end,
  },
}
