return {
  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- 'VonHeikemen/lsp-zero.nvim',
      'jay-babu/mason-null-ls.nvim',
      'williamboman/mason.nvim',
    },
    config = function()
      local null_ls = require('null-ls')
      null_ls.setup()
      require('mason-null-ls').setup({
        ensure_installed = require('config.sources').formatter,
        handlers = {},
        automatic_installation = true,
      })
    end,
  },
}
