local function map(mode, l, r, opts)
  opts = opts or {}
  opts.buffer = bufnr
  vim.keymap.set(mode, l, r, opts)
end
return {
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
          map('n', ']c', function()
            if vim.wo.diff then
              return ']c'
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return '<Ignore>'
          end, { expr = true })

          map('n', '[c', function()
            if vim.wo.diff then
              return '[c'
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return '<Ignore>'
          end, { expr = true })

          -- Actions
          map('n', '<leader>hs', gs.stage_hunk, { desc = 'Stage hunk' })
          map('n', '<leader>hr', gs.reset_hunk, { desc = 'Reset hunk' })
          map('v', '<leader>hs', function()
            gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end, { desc = 'Stage selection' })
          map('v', '<leader>hr', function()
            gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end, { desc = 'Reset selection' })
          map('n', '<leader>hS', gs.stage_buffer, { desc = 'Stage buffer' })
          map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'Unstage hunk' })
          map('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset buffer' })
          map('n', '<leader>hp', gs.preview_hunk_inline, { desc = 'Preview hunk' })
          map('n', '<leader>hd', gs.toggle_deleted, { desc = 'Toggle show deleted' })

          -- Text object
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end,
      })
    end,
  },
  {
    'f-person/git-blame.nvim',
    config = function()
      vim.g.gitblame_enabled = 1
      vim.g.gitblame_message_template = '<author> • <date> • <summary>'
      vim.g.gitblame_date_format = '%r'
      vim.g.gitblame_message_when_not_committed = ' Not Yet Committed'
      vim.g.gitblame_display_virtual_text = 1
      vim.g.gitblame_ignored_filetypes = require('config.filetype_excludes')
      vim.g.gitblame_delay = 1000

      map('n', 'gb', ':GitBlameToggle<CR>', { desc = 'Toggle blame' })
      map('n', '<Leader>gc', ':GitBlameOpenCommitURL<CR>', { desc = 'Open commit on GitHub' })
      map('n', '<Leader>gC', ':GitBlameCopySHA<CR>', { desc = 'Copy commit SHA' })
    end,
  },
  {
    'linrongbin16/gitlinker.nvim',
    config = function()
      require('gitlinker').setup({
        mapping = {
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
      map('n', '<Leader>gd', ':DiffviewOpen<CR>', { desc = 'Open git diff view' })
      map('n', '<Leader>gh', ':DiffviewFileHistory<CR>', { desc = 'Open file history' })
    end,
  },
}
