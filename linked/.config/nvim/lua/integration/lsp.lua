return {
  'neovim/nvim-lspconfig', -- Language server config support
  dependencies = {
    'williamboman/mason.nvim',
    -- Autocompletion
    { 'xzbdmw/colorful-menu.nvim' }, -- rich color
    -- Snippets (using cmp)
    -- Snippets (using cmp)
    -- Winbar breadcrumbs
    { 'SmiteshP/nvim-navic', dependencies = { 'neovim/nvim-lspconfig' } },
    -- LSP autokill for performance (disabled because it's too slow to start back up)
    -- { 'Zeioth/garbage-day.nvim', dependencies = { 'neovim/nvim-lspconfig' } },
    -- Inlay hints (insert-at-cursor helpers; display handled natively in config below)
    {
      'AbysmalBiscuit/insert-inlay-hints.nvim',
      keys = {
        {
          '<Leader>ii',
          function()
            require('insert-inlay-hints').closest()
          end,
          desc = 'Insert closest inlay hint.',
        },
        {
          '<Leader>il',
          function()
            require('insert-inlay-hints').line()
          end,
          desc = 'Insert inlay hints on current line.',
        },
        {
          '<Leader>i',
          function()
            require('insert-inlay-hints').visual()
          end,
          desc = 'Insert inlay hints in visual selection.',
          mode = { 'v' },
        },
        {
          '<Leader>ia',
          function()
            return require('insert-inlay-hints').all()
          end,
          desc = 'Insert all inlay hints in current buffer.',
        },
      },
    },
    {
      'chrisgrieser/nvim-rulebook',
      keys = {
        {
          '<Leader>rl',
          function()
            require('rulebook').lookupRule()
          end,
          desc = 'Open link to rule explanation'
        },
      },
    },
  },
  config = function() -- LSP loading status
    local lspconfig_defaults = require('lspconfig').util.default_config

    -- Ensure autocomplete capabilities
    -- lspconfig_defaults.capabilities =
    --   vim.tbl_deep_extend('force', lspconfig_defaults.capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- Set up keybinds and other special handling
    vim.api.nvim_create_autocmd('LspAttach', {
      desc = 'LSP actions',
      callback = function(event)
        local id = vim.tbl_get(event, 'data', 'client_id')
        local client = id and vim.lsp.get_client_by_id(id)

        if client == nil then
          return
        end

        -- Enable inlay hints
        if client:supports_method('textDocument/inlayHint') then
          vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
        end

        -- local opts = { buffer = event.buf }
        -- TODO: set keymaps here
      end,
    })

    -- Toggle inlay hint display
    vim.keymap.set('n', '<Leader>it', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, { desc = 'Toggle inlay hints.' })

    -- Inlay hints
    require('insert-inlay-hints').setup({
      disabled_filetypes = require('config.filetype_excludes'),
    })

    -- Solid border on hover/signatureHelp floats
    local hover = vim.lsp.buf.hover
    vim.lsp.buf.hover = function(opts)
      return hover(vim.tbl_extend('keep', opts or {}, { border = 'solid' }))
    end

    local signature_help = vim.lsp.buf.signature_help
    vim.lsp.buf.signature_help = function(opts)
      return signature_help(vim.tbl_extend('keep', opts or {}, { border = 'solid' }))
    end

    -- Load language-specific configuration
    require('config.language-specific')

    -- Load vscode snippets
    require('luasnip.loaders.from_vscode').lazy_load()
  end,
}
