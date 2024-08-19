local util = require('util')
return {
  { -- quick selection by syntax node
    'sustech-data/wildfire.nvim',
    lazy = false,
    event = 'UIEnter',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('wildfire').setup({
        filetype_exclude = require('config.filetype_excludes'),
      })
    end,
  },
  { -- Automatic block split/join
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({
        use_default_keymaps = false,
      })
      vim.keymap.set('n', '<Leader>gs', ':TSJToggle<CR>', { desc = 'Split/join block using Treesitter' })
    end,
  },
  { -- Used mainly to add quote text objects
    'chrisgrieser/nvim-various-textobjs',
    lazy = false,
    opts = {
      useDefaultKeymaps = true,
      disabledKeymaps = {
        'ag',
        'ig',
        'iS',
        'aS',
        'gc',
      },
    },
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
  { -- Quick search and replace
    'roobert/search-replace.nvim',
    config = function()
      require('search-replace').setup({})
      vim.keymap.set('n', '<Leader>rr', '<CMD>SearchReplaceSingleBufferCWord<CR>', {
        desc = 'Search and replace selected',
      })
      vim.keymap.set('v', '<Leader>rr', '"sy:%s/<C-r>s//gc<left><left><left>', {
        desc = 'Search and replace selected',
      })
      vim.keymap.set('n', '<Leader>rs', function()
        vim.cmd('SearchReplaceSingleBufferOpen')
      end, {
        desc = 'Search and replace...',
      })
      vim.keymap.set('v', '<Leader>rs', '<CMD>SearchReplaceWithinVisualSelection<CR>', {
        desc = 'Search and replace within selection',
      })
    end,
  },
  { -- Smart handling of surrounding brackets
    'kylechui/nvim-surround',
    dependencies = { 'ggandor/lightspeed.nvim' }, -- ensure it loads after
    version = '*',
    config = function()
      require('nvim-surround').setup({
        keymaps = {
          visual = 'gs',
          delete = 'dgs',
          change = 'cgs',
        },
      })
    end,
  },
}
