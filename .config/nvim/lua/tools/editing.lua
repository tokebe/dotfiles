local util = require('util')
return {
  { -- quick selection by syntax node
    'sustech-data/wildfire.nvim',
    lazy = false,
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
  { -- Adds sensible textobjs for selection/operation
    'echasnovski/mini.ai',
    version = '*',
    config = function()
      require('mini.ai').setup()
    end,
  },
  {
    'chrisgrieser/nvim-various-textobjs',
    event = 'VeryLazy',
    opts = { keymaps = { useDefaults = true } },
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
  {
    'jake-stewart/multicursor.nvim',
    config = function()
      local mc = require('multicursor-nvim')
      mc.setup()
      -- add cursors above/below the main cursor
      vim.keymap.set({ 'n', 'v' }, '<up>', function()
        mc.addCursor('k')
      end, { desc = 'Add cursor above' })
      vim.keymap.set({ 'n', 'v' }, '<down>', function()
        mc.addCursor('j')
      end, { desc = 'Add cursor below' })

      -- add a cursor and jump to the next word under cursor
      vim.keymap.set({ 'n', 'v' }, '<c-n>', function()
        mc.addCursor('*')
      end, { desc = 'Add cursor at next match' })

      -- jump to the next word under cursor but do not add a cursor
      vim.keymap.set({ 'n', 'v' }, '<c-s>', function()
        mc.skipCursor('*')
      end, { desc = 'Skip to next match' })

      -- rotate the main cursor
      vim.keymap.set({ 'n', 'v' }, '<left>', mc.nextCursor, { desc = 'Switch to next cursor' })
      vim.keymap.set({ 'n', 'v' }, '<right>', mc.prevCursor, { desc = 'Switch to previous cursor' })

      -- delete the main cursor
      vim.keymap.set({ 'n', 'v' }, '<leader>mx', mc.deleteCursor, { desc = 'Delete current cursor' })

      -- add and remove cursors with control + left click
      vim.keymap.set('n', '<c-leftmouse>', mc.handleMouse, { desc = 'Add cursor with mouse' })

      vim.keymap.set({ 'n', 'v' }, '<c-q>', function()
        if mc.cursorsEnabled() then
          -- stop other cursors from moving. this allows you to reposition the main cursor
          mc.disableCursors()
        else
          mc.addCursor()
        end
      end, { desc = 'Pause other cursors / Add cursor at new position' })

      vim.keymap.set('n', '<esc>', function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.firstCursor()
          mc.clearCursors()
        else
          -- default <esc> handler
        end
      end, { desc = 'Exit multi-cursor' })

      -- align cursor columns
      vim.keymap.set('n', '<leader>ma', mc.alignCursors, { desc = 'Align cursor columns' })

      -- split visual selections by regex
      vim.keymap.set('v', '<Leader>ms', mc.splitCursors, { desc = 'Split selection by regex and add cursors' })

      -- match new cursors within visual selections by regex
      vim.keymap.set(
        { 'n', 'v' },
        '<Leader>mm',
        mc.matchCursors,
        { desc = 'Add cursors at regex instances in selection' }
      )

      -- rotate visual selection contents
      -- vim.keymap.set('v', '<leader>mr', function()
      --   mc.transposeCursors(1)
      -- end, { desc = 'Transpose multi-selections' })
      -- vim.keymap.set('v', '<leader>mR', function()
      --   mc.transposeCursors(-1)
      -- end, { desc = 'Transpose multi-selections (reverse)' })

      -- customize how cursors look
      vim.cmd.hi('link', 'MultiCursorCursor', 'Cursor')
      vim.cmd.hi('link', 'MultiCursorVisual', 'Visual')
      vim.cmd.hi('link', 'MultiCursorDisabledCursor', 'Visual')
      vim.cmd.hi('link', 'MultiCursorDisabledVisual', 'Visual')
    end,
  },
  -- TODO: add neogen https://github.com/danymat/neogen
}
