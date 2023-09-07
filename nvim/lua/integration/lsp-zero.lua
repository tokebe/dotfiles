local util = require('util')
return {
  'VonHeikemen/lsp-zero.nvim', -- Automatic LSP setup
  branch = 'v2.x',
  dependencies = {
    { 'neovim/nvim-lspconfig' }, -- Language server config support
    'williamboman/mason-lspconfig.nvim', -- Automatic installation/configuration of LSPs
    -- Autocompletion
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp', dependencies = { 'hrsh7th/nvim-cmp' } },
    { 'rcarriga/cmp-dap', dependencies = { 'hrsh7th/nvim-cmp', 'mfussenegger/nvim-dap' } },
    -- { 'hrsh7th/cmp-nvim-lsp-signature-help' },
    { 'hrsh7th/cmp-buffer', dependencies = { 'hrsh7th/nvim-cmp' } },
    { 'hrsh7th/cmp-cmdline', dependencies = { 'hrsh7th/nvim-cmp' } },
    { 'dmitmel/cmp-cmdline-history', dependencies = { 'hrsh7th/nvim-cmp' } },
    { 'tamago324/cmp-zsh', dependencies = { 'hrsh7th/nvim-cmp' } },
    { 'onsails/lspkind.nvim', dependencies = { 'hrsh7th/nvim-cmp' } }, -- icons
    -- Snippets (using cmp)
    {
      'L3MON4D3/LuaSnip',
      dependencies = { 'hrsh7th/nvim-cmp', 'saadparwaiz1/cmp_luasnip', 'rafamadriz/friendly-snippets' },
    },
    -- Inlay type hints
    { 'lvimuser/lsp-inlayhints.nvim' },
    -- Winbar breadcrumbs
    { 'SmiteshP/nvim-navic', dependencies = { 'neovim/nvim-lspconfig' } },
  },
  -- TODO fix occasional (load order?) error between this and mason-lspconfig
  config = function() -- LSP loading status
    local lsp = require('lsp-zero').preset({
      name = 'recommended',
      set_lsp_keymaps = { preserve_mappings = true, omit = { 'K' } },
    })

    lsp.set_sign_icons({
      error = ' ',
      warn = ' ',
      hint = ' ',
      info = '󱉵 ',
    })

    lsp.on_attach(function(client, bufnr)
      -- LSP actions
      util.keymap('n', 'gd', ':Trouble lsp_definitions<CR>')
      util.keymap('n', 'gi', ':Trouble lsp_implementations<CR>')
      util.keymap('n', 'gt', ':Trouble lsp_type_definitions<CR>')
      util.keymap('n', 'gr', ':Trouble lsp_references<CR>')
      util.keymap('n', '<F2>', ':IncRename' .. vim.fn.expand('<cword>'))
      util.keymap('n', '<F4>', ':lua require("actions-preview").code_actions()<CR>')
      util.keymap('x', '<F4>', ':lua require("actions-preview").code_actions()<CR>')

      -- attach for breadcrumbs (see barbecue)
      if client.server_capabilities['documentSymbolProvider'] then
        require('nvim-navic').attach(client, bufnr)
      end

      -- attach inlay hints
      require('lsp-inlayhints').on_attach(client, bufnr, true)
    end)

    -- Load language-specific configuration
    -- TODO make this automated
    require('config.language-specific.python')
    require('config.language-specific.lua')

    -- Set up lua_ls for nvim work
    -- TODO make this only happen in certain circumstances
    require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

    -- Finalize lsp-zero setup
    lsp.setup()

    -- Remove borders on hover/signatureHelp
    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'none' })
    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'shadow' })

    -- Set up completion using lsp-zero, etc.
    require('config.cmp').config(lsp)

    util.keymap('n', '<Leader>od', function()
      require('toggle_lsp_diagnostics').toggle_virtual_text()
    end, {
      desc = 'Toggle LSP diagnostic text',
    })
  end,
}
