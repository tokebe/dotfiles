local myLsps = {
  'lua_ls',
  'tsserver',
}

return {
  'VonHeikemen/lsp-zero.nvim', -- Automatic LSP setup
  branch = 'v2.x',
  dependencies = {
    { 'neovim/nvim-lspconfig' }, -- Language server support
    {
      'williamboman/mason.nvim', -- Automatic LSP/DAP/linter/formatter management
      build = function()
        pcall(vim.cmd, 'MasonUpdate')
      end,
    },
    { 'williamboman/mason-lspconfig.nvim' }, -- integration
    -- Autocompletion
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'L3MON4D3/LuaSnip' },
    { 'folke/neodev.nvim' },
    { 'onsails/lspkind.nvim' }, -- icons
    -- Formatting
    { 'lukas-reineke/lsp-format.nvim' },
  },
  config = function()
    -- Set up LSP
    local lsp = require('lsp-zero').preset()

    lsp.set_sign_icons({
      error = '✘',
      warn = '▲',
      hint = '⚑',
      info = '»'
    })

    require('lsp-format').setup()

    lsp.on_attach(
      function(client, bufnr)
        require('lsp-format').on_attach(client, bufnr)
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
              border = 'rounded',
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
      ensure_installed = myLsps,
      automatic_installation = true,
    })

    -- Configure lua language server for neovim
    require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

    lsp.setup()

    -- Set up completion etc
    require('neodev').setup()
    local luasnip = require('luasnip')
    luasnip.setup({})
    local cmp = require('cmp')
    local cmp_action = require('lsp-zero').cmp_action()

    cmp.setup({
      sources = {                                                -- completion sources
        { name = 'nvim_lsp' },                                   -- language server
        { name = 'nvim_lsp_signature_help' },
        { name = 'luasnip',                keyword_length = 2 }, -- snippets
        { name = 'async-path' },                                 -- filepath
        { name = 'buffer',                 keyword_length = 3 }, -- current file
      },
      formatting = {
        format = require('lspkind').cmp_format({
          mode = 'symbol_text',
          maxwidth = 50,
          ellipsis_char = '...',
          before = function(entry, vim_item)
            return vim_item -- see lspkind #30
          end
        }),
      },
      mapping = {
        ['<Tab>'] = cmp.mapping(function(fallback)
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif cmp.visible() then
            cmp.confirm({ select = true })
          else
            fallback()
          end
        end),
        -- ['<Esc>'] = cmp.mapping.abort()
      }
    })

    -- Use buffer for completion in search
    -- cmp.setup.cmdline({ '/', '?' }, {
    --   mapping = cmp.mapping.preset.cmdline(),
    --   sources = { name = 'buffer' }
    -- })
    --
    -- Cmdline and path completion for commands
    -- cmp.setup.cmdline(':', {
    --   mapping = cmp.mapping.preset.cmdline(),
    --   sources = {
    --     { name = 'async-path' },
    --     { name = 'cmdline' },
    --     { name = 'cmdline_history' }
    --   },
    -- })
  end
}
