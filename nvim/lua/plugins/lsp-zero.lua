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
    { 'folke/neodev.nvim' },
    -- Autocompletion
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-nvim-lsp-signature-help' },
    { 'L3MON4D3/LuaSnip' },
    { 'hrsh7th/cmp-buffer' },
    { 'FelipeLema/cmp-async-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'dmitmel/cmp-cmdline-history' },
    { 'tamago324/cmp-zsh' },
    { 'onsails/lspkind.nvim' }, -- icons
    -- Formatting
    -- { 'lukas-reineke/lsp-format.nvim' },
    -- Indicator
    { 'j-hui/fidget.nvim' },
    -- LSP rename preview
    { 'smjonas/inc-rename.nvim',            dependencies = { 'stevearc/dressing.nvim' } },
  },
  config = function()
    -- Set up neodev
    require('neodev').setup({})
    -- Set up Dressing
    require('dressing').setup({
      input = {
        override = function(conf)
          conf.col = -1
          conf.row = 0
          return conf
        end,
        border = 'rounded'
      },
    })
    -- Set up IncRename
    require('inc_rename').setup({
      input_buffer_type = 'dressing',
    })
    vim.keymap.set("n", "<leader>gr", function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end, { expr = true })
    -- Set up LSP
    local lsp = require('lsp-zero').preset('recommended')

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
      ensure_installed = myLsps,
      automatic_installation = true,
    })

    lsp.setup()
    require('fidget').setup() -- LSP loading status
    -- Format keybind
    vim.keymap.set('n', '<leader>gf', function()
      vim.lsp.buf.format({ async = true })
    end, { desc = 'Format Buffer' })
    -- buffer
    vim.keymap.set('v', '<leader>gf', function()
      vim.lsp.buf.format({
        async = true,
        range = {
          ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
          ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
        }
      })
    end, { desc = 'Format Visual' })

    -- Set up completion etc
    local luasnip = require('luasnip')
    -- luasnip.setup({})
    local cmp = require('cmp')

    cmp.setup(lsp.defaults.cmp_config({
      sources = {                                                -- completion sources
        { name = 'nvim_lsp' },                                   -- language server
        { name = 'nvim_lsp_signature_help' },
        { name = 'luasnip',                keyword_length = 2 }, -- snippets
        { name = 'async-path' },                                 -- filepath
        { name = 'buffer',                 keyword_length = 3 }, -- current file
      },
      formatting = {
        -- Icons
        format = require('lspkind').cmp_format({
          mode = 'symbol_text',
          maxwidth = 50,
          ellipsis_char = '...',
          before = function(_, vim_item)
            return vim_item -- see lspkind #30
          end
        }),
      },
      mapping = {
        ['<Tab>'] = cmp.mapping(function(fallback)
          if luasnip.expandable() then
            luasnip.expand()
          elseif cmp.visible() then
            cmp.confirm({ select = true })
          else
            fallback()
          end
        end),
        -- ['<Esc>'] = cmp.mapping.abort()
      }
    }))

    -- Use buffer for completion in search
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = { name = 'buffer' }
    })

    -- Cmdline and path completion for commands
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'cmdline' },
        { name = 'async-path' },
        { name = 'cmdline_history' },
        { name = 'zsh' },
      },
    })
  end
}
