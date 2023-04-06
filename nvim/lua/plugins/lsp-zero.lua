local myLsps = {
  'lua_ls'
}

return {
  'VonHeikemen/lsp-zero.nvim',
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
    { 'lukas-reineke/lsp-format.nvim' },
  },
  config = function()
    local lsp = require('lsp-zero').preset({})
    lsp.preset('lsp-zero')

    lsp.on_attach(
      function(client, bufnr)
        require('lsp-format').on_attach(client, bufnr)
      end
    )

    require('mason-lspconfig').setup({
      ensure_installed = myLsps,
      automatic_installation = true,
    })

    lsp.nvim_workspace()
    -- Configure lua language server for neovim
    require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

    lsp.setup()
  end
}
