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

      -- prettierd rejects CLI options; it reads a prettier config file, falling
      -- back to PRETTIERD_DEFAULT_CONFIG. Point that at our markdown wrap config
      -- (proseWrap=always, printWidth=88) so it applies when a project has none.
      vim.env.PRETTIERD_DEFAULT_CONFIG = vim.fn.stdpath('config') .. '/prettierd-default.json'

      require('mason-null-ls').setup({
        ensure_installed = require('config.sources').formatter,
        automatic_installation = true,
        -- handlers[1] is unset, so every source except those keyed below still
        -- registers via mason-null-ls.default_setup.
        handlers = {
          -- Restrict prettierd to markdown so it only hard-wraps notes and
          -- never competes with the dedicated formatters on other filetypes.
          prettierd = function()
            null_ls.register(null_ls.builtins.formatting.prettierd.with({
              filetypes = { 'markdown' },
            }))
          end,
        },
      })
    end,
  },
}
