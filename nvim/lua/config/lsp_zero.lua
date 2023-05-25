local lsps = require('config.sources').lsp
return {
  config = function(lsp)

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

      local map = function(mode, lhs, rhs)
        local opts = { remap = false, buffer = bufnr }
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- LSP actions
      map('n', 'gd', ':Trouble lsp_definitions<CR>')
      map('n', 'gi', ':Trouble lsp_implementations<CR>')
      map('n', 'gt', ':Trouble lsp_type_definitions<CR>')
      map('n', 'gr', ':Trouble lsp_references<CR>')
      map('n', '<F2>', ':IncRename' .. vim.fn.expand('<cword>'))
      map('n', '<F4>', ':lua require("actions-preview").code_actions()<CR>')
      map('x', '<F4>', ':lua require("actions-preview").code_actions()<CR>')


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
      if client.server_capabilities['documentSymbolProvider'] then
        require('nvim-navic').attach(client, bufnr)
      end

      -- attach inlay hints
      require('lsp-inlayhints').on_attach(client, bufnr, true)
    end)
    require('mason-lspconfig').setup({
      ensure_installed = lsps,
      automatic_installation = true,
    })

    lsp.nvim_workspace() -- Fix "undefined global 'vim'"

    -- lsp.set_server_config({
    --   -- Add requirement for UFO providing folds
    --   capabilities = {
    --     textDocument = {
    --       foldingRange = {
    --         dynamicRegistration = false,
    --         lineFoldingOnly = true,
    --       },
    --     },
    --   },
    -- })

    lsp.setup()

    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'none' })

    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'none' })
  end,
}
