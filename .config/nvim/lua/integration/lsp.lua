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
    -- LSP autokill for performance
    { 'Zeioth/garbage-day.nvim', dependencies = { 'neovim/nvim-lspconfig' } },
    -- Inlay hints
    { 'MysticalDevil/inlay-hints.nvim', event = 'LspAttach' },
    {
      'AbysmalBiscuit/insert-inlay-hints.nvim',
      keys = {
        {
          '<leader>ic',
          function()
            require('insert-inlay-hints').closest()
          end,
          desc = 'Insert closest inline hint.',
        },
        {
          '<leader>il',
          function()
            require('insert-inlay-hints').line()
          end,
          desc = 'Insert inline hints on current line.',
        },
        {
          '<leader>i',
          function()
            require('insert-inlay-hints').visual()
          end,
          desc = 'Insert inlay hints in visual selection.',
          mode = { 'v' },
        },
        {
          '<leader>ia',
          function()
            return require('insert-inlay-hints').all()
          end,
          desc = 'Insert all inlay hints in current buffer.',
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

        -- local opts = { buffer = event.buf }
        -- TODO: set keymaps here
      end,
    })

    -- Inlay hints
    require('inlay-hints').setup()
    require('insert-inlay-hints').setup({
      disabled_filetypes = require('config.filetype_excludes'),
    })

    -- Integrate with mason
    require('mason').setup({})
    vim.keymap.set('n', '<Leader>om', ':Mason<CR>', {
      desc = 'Manage LSPs with Mason',
    })

    -- Remove borders on hover/signatureHelp
    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'solid' })
    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'solid' })

    -- Load language-specific configuration
    require('config.language-specific.python')
    require('config.language-specific.lua')

    -- Load vscode snippets
    require('luasnip.loaders.from_vscode').lazy_load()

    require('garbage-day').setup({
      grace_period = 60 * 20, -- in s
      wakeup_delay = 10, -- in ms
      notifications = true,
    })
  end,
}
