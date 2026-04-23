local filter = require('filter')
return {
  {
    'MagicDuck/grug-far.nvim',
    version = '1',
    config = function()
      local grug = require('grug-far')
      grug.setup({
        startInInsertMode = false,
        keymaps = {
          close = { n = 'q' },
          qflist = { n = '<Leader>q' },
        },
        prefills = {
          flags = '--smart-case --no-ignore --hidden',
        },
        transient = true,
      })

      -- override the built-in qflist binding so it also closes grug-far.
      -- vim.schedule defers past grug-far's own keymap setup, which runs synchronously
      -- after it sets filetype=grug-far (and would otherwise clobber this binding).
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'grug-far',
        callback = function(ev)
          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(ev.buf) then
              return
            end
            vim.keymap.set('n', '<Leader>q', function()
              local instance = grug.get_instance(ev.buf)
              instance:open_quickfix()
              instance:close()
            end, { buffer = ev.buf, desc = 'Send to quickfix and close grug-far' })
          end)
        end,
      })

      vim.keymap.set({ 'n', 'v' }, '<Leader>ff', function()
        grug.open({
          prefills = {
            filesFilter = '!' .. filter.getFilter(),
          },
        })
      end, { desc = 'Search within files' })

      vim.keymap.set({ 'n', 'v' }, '<Leader>fF', function()
        grug.open({
          prefills = {
            filesFilter = vim.fn.expand('%:.'),
          },
        })
      end, { desc = 'Search within current file' })

      vim.keymap.set({ 'n', 'v' }, '<Leader>fa', function()
        grug.open({
          engine = 'astgrep',
          prefills = {
            filesFilter = '!' .. filter.getFilter(),
            flags = '',
          },
        })
      end, { desc = 'Search AST within files' })

      vim.keymap.set({ 'n', 'v' }, '<Leader>fA', function()
        grug.open({
          engine = 'astgrep',
          prefills = {
            filesFilter = vim.fn.expand('%:.'),
            flags = '',
          },
        })
      end, { desc = 'Search AST within current file' })
    end,
  },
}
