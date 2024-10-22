local util = require('util')
return {
  -- Tools
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  {
    'linrongbin16/gitlinker.nvim',
    lazy = false,
    config = function()
      local gitlinker = require('gitlinker')
      gitlinker.setup({
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
      vim.keymap.set('n', '<Leader>gd', ':DiffviewOpen<CR>', { desc = 'Open git diff view' })
      vim.keymap.set('n', '<Leader>gh', ':DiffviewFileHistory<CR>', { desc = 'Open file history' })
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
        preview_config = {
          border = 'solid',
        },
        current_line_blame = true,
        current_line_blame_formatter = '<author> • <author_time:%R> • <summary>',
        current_line_blame_opts = {
          delay = 1000,
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
          vim.keymap.set('n', '<leader>hs', gs.stage_hunk, { desc = 'Stage hunk' })
          vim.keymap.set('n', '<leader>hr', gs.reset_hunk, { desc = 'Reset hunk' })
          vim.keymap.set('v', '<leader>hs', function()
            gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end, { desc = 'Stage selection' })
          vim.keymap.set('v', '<leader>hr', function()
            gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end, { desc = 'Reset selection' })
          vim.keymap.set('n', '<leader>hS', gs.stage_buffer, { desc = 'Stage buffer' })
          vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'Unstage hunk' })
          vim.keymap.set('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset buffer' })
          vim.keymap.set('n', '<leader>hp', gs.preview_hunk_inline, { desc = 'Preview hunk' })
          vim.keymap.set('n', '<leader>hd', gs.toggle_deleted, { desc = 'Toggle show deleted' })

          -- Text object
          vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')

          vim.keymap.set(
            'n',
            '<Leader>tb',
            '<CMD>Gitsigns toggle_current_line_blame<CR>',
            { desc = 'Toggle hover blame' }
          )
          vim.keymap.set('n', 'gb', '<CMD>Gitsigns blame_line<CR>', { desc = 'View line blame' })
        end,
      })
    end,
  },
  {
    'FabijanZulj/blame.nvim', -- TODO: setup
    config = function()
      require('blame').setup({
        virtual_style = 'float',
        blame_opts = { '--color-by-age' },
        format_fn = require('blame.formats.default_formats').date_message,
      })
      vim.keymap.set('n', 'gB', '<CMD>BlameToggle<CR>', { desc = 'Toggle blame mode' })
    end,
  },
}
