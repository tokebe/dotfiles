return {
  { -- Insert new bullets automatically
    'dkarter/bullets.vim',
    config = function()
      local g = vim.g
      g.bullets_enabled_file_types = {
        'markdown',
        'text',
        'gitcommit',
        'yaml',
        '',
      }
      g.bullets_set_mappings = 1
      g.bullets_delete_last_bullet_if_empty = 1
      g.bullets_pad_right = 0
      g.bullets_auto_indent_after_colon = 1
      g.bullets_renumber_on_change = 1
      g.bullets_nested_checkboxes = 1
      g.bullets_checkbox_markers = ' x'
    end,
  },
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
      vim.keymap.set('n', '<Leader>gs', ':TSJToggle<CR>', { desc = 'Split/join block using Treesitter' })
    end,
  },
  { -- Use treesitter to navigate by syntax nodes
    'drybalka/tree-climber.nvim',
    config = function()
      vim.keymap.set({ 'n', 'v', 'o' }, '<Leader>jj', function()
        require('tree-climber').goto_next({ highlight = true })
      end, { desc = 'Jump to next node' })
      vim.keymap.set({ 'n', 'v', 'o' }, '<Leader>jk', function()
        require('tree-climber').goto_prev({ highlight = true })
      end, { desc = 'Jump to previous node' })
      vim.keymap.set({ 'n', 'v', 'o' }, '<Leader>jh', function()
        require('tree-climber').goto_parent({ highlight = true })
      end, { desc = 'Jump to parent node' })
      vim.keymap.set({ 'n', 'v', 'o' }, '<Leader>jl', function()
        require('tree-climber').goto_child({ highlight = true })
      end, { desc = 'Jump to child node' })
      vim.keymap.set({ 'v' }, 'in', require('tree-climber').select_node, { desc = '' })
      vim.keymap.set({ 'n' }, '<Leader>nk', function()
        require('tree-climber').swap_prev({ highlight = true })
      end, { desc = 'swap node with previous' })
      vim.keymap.set({ 'n' }, '<Leader>nj', function()
        require('tree-climber').swap_next({ highlight = true })
      end, { desc = 'swap node with next' })
      vim.keymap.set({ 'n' }, '<Leader>nh', require('tree-climber').highlight_node, { desc = 'swap node with next' })
    end,
  },
  { -- Open links
    'xiyaowong/link-visitor.nvim',
    config = function()
      vim.keymap.set({ 'n' }, '<Leader>gu', require('link-visitor').link_nearest, { desc = 'Open nearest URL' })
    end,
  },
  { -- Turbocharged jump-by-type
    'ggandor/lightspeed.nvim',
    dependencies = {
      'tpope/vim-repeat',
    },
    config = function()
      require('lightspeed').setup({})
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
  { -- Delete buffers but preserve window layout
    'ojroques/nvim-bufdel',
    config = function()
      require('bufdel').setup({
        quit = false,
      })
    end,
  },
  { -- d deletes instead of cuts, D now cuts
    'gbprod/cutlass.nvim',
    config = function()
      require('cutlass').setup({
        cut_key = 'D',
        exclude = { 'ns', 'nS' }, -- Avoid conflict with lightspeed.nvim
        registers = {
          select = 's',
          delete = 'd',
          change = 'c',
        },
      })
    end,
  },
  { -- Intelligent paste indenting. Not treesitter-intelligent; doesn't work on .py etc.
    'ku1ik/vim-pasta',
  },
  {
    'smoka7/multicursors.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'anuvyklack/hydra.nvim' },
    opts = {
      updatetime = 10,
      generate_hints = {
        normal = true,
        insert = true,
        extend = true,
      },
    },
    cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
    keys = {
      {
        mode = { 'v', 'n' },
        '<Leader>mm',
        ':MCstart<CR>',
        desc = 'Start multicursors on selection',
      },
    },
  },
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  },
}
