return {
  {
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
  {
    'sustech-data/wildfire.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('wildfire').setup()
    end,
  },
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({
        use_default_keymaps = false,
      })
      vim.keymap.set('n', '<Leader>gs', ':TSJToggle<CR>', { desc = 'Split/join block using Treesitter' })
    end,
  },
  {
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
      vim.keymap.set({ 'n' }, '<c-k>', function()
        require('tree-climber').swap_prev({ highlight = true })
      end, { desc = 'swap node with previous' })
      vim.keymap.set({ 'n' }, '<c-j>', function()
        require('tree-climber').swap_next({ highlight = true })
      end, { desc = 'swap node with next' })
      vim.keymap.set({ 'n' }, '<c-h>', require('tree-climber').highlight_node, { desc = 'swap node with next' })
    end,
  },
  {
    'xiyaowong/link-visitor.nvim',
    config = function()
      vim.keymap.set({ 'n' }, '<Leader>gu', require('link-visitor').link_nearest, { desc = 'Open nearest URL' })
    end,
  },
  {
    'ggandor/lightspeed.nvim',
    dependencies = {
      'tpope/vim-repeat',
    },
    config = function()
      require('lightspeed').setup({
        ignore_case = true,
      })
    end,
  },
}
