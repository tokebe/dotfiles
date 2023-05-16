local lsps = require('config.sources').lsp
return {
  config = function(lsp)
    -- Set up some requirements for UFO (folding)
    vim.o.foldcolumn = '1' -- '0' is not bad
    vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    require('ufo').setup()

    lsp.set_sign_icons({
      error = '✘',
      warn = '▲',
      hint = '⚑',
      info = '»',
    })

    lsp.on_attach(function(client, bufnr)
      -- require('lsp-format').on_attach(client, bufnr)
      -- keymaps
      lsp.default_keymaps({
        buffer = bufnr,
        preserve_mappings = false,
      })

      -- diagnostics float on cursor
      vim.api.nvim_create_autocmd('CursorHold', {
        buffer = bufnr,
        callback = function()
          local opts = {
            focusable = false,
            close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
            border = 'none',
            source = 'always',
            prefix = ' ',
            scope = 'cursor',
          }
          vim.diagnostic.open_float(nil, opts)
        end,
      })

      -- attach for breadcrumbs (see barbecue)
      if client.server_capabilities['documentsSymbolProvider'] then
        require('nvim-navic').attach(client, bufnr)
      end

      -- attach inlay hints
      require('lsp-inlayhints').on_attach(client, bufnr)
    end)
    require('mason-lspconfig').setup({
      ensure_installed = lsps,
      automatic_installation = true,
    })

    lsp.nvim_workspace() -- Fix "undefined global 'vim'"

    lsp.set_server_config({
      -- Add requirement for UFO providing folds
      capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      },
    })

    lsp.setup()
  end,
}
