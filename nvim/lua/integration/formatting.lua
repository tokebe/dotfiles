return {
  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'VonHeikemen/lsp-zero.nvim',
      'jay-babu/mason-null-ls.nvim',
      'williamboman/mason.nvim',
    },
    config = function()
      local null_ls = require('null-ls')
      require('mason-null-ls').setup({
        ensure_installed = require('config.sources').formatter,
        automatic_setup = true,
        handlers = {
          yamllint = function()
            null_ls.register(null_ls.builtins.diagnostics.yamllint.with({
              extra_args = {
                '-d',
                'relaxed',
              },
            }))
          end,
          -- Supplying empty functions makes null_ls handle it instead
          yamlfix = function() end,
          prettier = function() end,
        },
      })
      -- Specify yamlfix before prettier so it loads first
      -- (This applies yamlfix formatting and then prettier to yaml files)
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.yamlfix,
          null_ls.builtins.formatting.prettier,
        },
      })
    end,
  },
}
