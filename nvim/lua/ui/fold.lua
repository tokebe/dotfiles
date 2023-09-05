local util = require('util')
return {
  {
    'anuvyklack/fold-preview.nvim',
    dependencies = {
      { 'anuvyklack/keymap-amend.nvim' },
    },
    config = function()
      require('fold-preview').setup({
        auto = 400,
        border = 'none',
      })
    end,
  },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    config = function()
      -- Set up some requirements for UFO (folding)
      vim.o.foldcolumn = '1' -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end,
      })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = require('config.filetype_excludes'),
        callback = function()
          require('ufo').detach()
          vim.opt_local.foldenable = false
        end,
      })

      util.keymap('n', 'zR', require('ufo').openAllFolds, {
        desc = 'Open all folds',
      })
      util.keymap('n', 'zM', require('ufo').closeAllFolds, {
        desc = 'Close all folds',
      })
    end,
  },
}
