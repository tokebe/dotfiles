local lsps = require('config.sources').lsp
return {
  config = function(lsp)
    lsp.set_sign_icons({
      error = '✘',
      warn = '▲',
      hint = '⚑',
      info = '»'
    })
    lsp.on_attach(
      function(client, bufnr)
        -- require('lsp-format').on_attach(client, bufnr)
        -- keymaps
        lsp.default_keymaps({
          buffer = bufnr,
          preserve_mappings = false,
        })

        -- diagnostics float on cursor
        vim.api.nvim_create_autocmd("CursorHold", {
          buffer = bufnr,
          callback = function()
            local opts = {
              focusable = false,
              close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
              border = 'none',
              source = 'always',
              prefix = ' ',
              scope = 'cursor',
            }
            vim.diagnostic.open_float(nil, opts)
          end
        })

        -- attach for breadcrumbs (see barbecue)
        if client.server_capabilities['documentsSymbolProvider'] then
          require('nvim-navic').attach(client, bufnr)
        end
      end
    )
    require('mason-lspconfig').setup({
      ensure_installed = lsps,
      automatic_installation = true,
    })

    lsp.setup()
  end
}
