local util = require('util')
return {
  -- Tools
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  {
    'linrongbin16/gitlinker.nvim',
    config = function()
      require('gitlinker').setup({
        mappings = {
          ['<Leader>gl'] = {
            action = require('gitlinker.actions').system,
            desc = 'Open on GitHub',
          },
          ['<Leader>gL'] = {
            action = require('gitlinker.actions').clipboard,
            desc = 'Copy GitHub link to clipboard',
          },
        },
      })
    end,
  },
  {
    'sindrets/diffview.nvim',
    config = function()
      local actions = require('diffview.actions')
      require('diffview').setup({
        file_panel = {
          win_config = {
            position = 'right',
          },
        },
        keymaps = {
          view = {
            { 'n', 'q', actions.close, { desc = 'Close Diffview' } },
          },
          file_panel = {
            { 'n', 'q', actions.close, { desc = 'Close Diffview' } },
          },
          file_history_panel = {
            { 'n', 'q', actions.close, { desc = 'Close Diffview' } },
          },
        },
      })
      util.keymap('n', '<Leader>gd', ':DiffviewOpen<CR>', { desc = 'Open git diff view' })
      util.keymap('n', '<Leader>gh', ':DiffviewFileHistory<CR>', { desc = 'Open file history' })
    end,
  },
  -- UI
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        signs = {
          add = { text = '│' },
          change = { text = '│' },
          delete = { text = '│' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          -- Navigation
          vim.keymap.set('n', ']c', function()
            if vim.wo.diff then
              return ']c'
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return '<Ignore>'
          end, { expr = true })

          vim.keymap.set('n', '[c', function()
            if vim.wo.diff then
              return '[c'
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return '<Ignore>'
          end, { expr = true })

          -- Actions
          util.keymap('n', '<leader>hs', gs.stage_hunk, { desc = 'Stage hunk' })
          util.keymap('n', '<leader>hr', gs.reset_hunk, { desc = 'Reset hunk' })
          util.keymap('v', '<leader>hs', function()
            gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end, { desc = 'Stage selection' })
          util.keymap('v', '<leader>hr', function()
            gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end, { desc = 'Reset selection' })
          util.keymap('n', '<leader>hS', gs.stage_buffer, { desc = 'Stage buffer' })
          util.keymap('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'Unstage hunk' })
          util.keymap('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset buffer' })
          util.keymap('n', '<leader>hp', gs.preview_hunk_inline, { desc = 'Preview hunk' })
          util.keymap('n', '<leader>hd', gs.toggle_deleted, { desc = 'Toggle show deleted' })

          -- Text object
          util.keymap({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end,
      })
    end,
  },
  {
    'f-person/git-blame.nvim',
    config = function()
      require('gitblame').setup({
        enabled = 1,
        message_template = '<author> • <date> • <summary>',
        date_format = '%r',
        message_when_not_committed = ' Not Yet Committed',
        display_virtual_text = 1,
        ignored_filetypes = require('config.filetype_excludes'),
        delay = 1000,
      })

      util.keymap('n', 'gb', ':GitBlameToggle<CR>', { desc = 'Toggle blame' })
      util.keymap('n', '<Leader>gc', ':GitBlameOpenCommitURL<CR>', { desc = 'Open commit on GitHub' })
      util.keymap('n', '<Leader>gC', ':GitBlameCopySHA<CR>', { desc = 'Copy commit SHA' })
    end,
  },
}
