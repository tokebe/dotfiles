return {
  lsp = { -- Language Server Protocol
    'lua_ls',
    'tsserver',
    'pylsp',
  },
  dap = { -- Debug Adapter Protocol
    'node-debug2-adapter',
    'debugpy'
  },
  formatter = {
    -- formatters
    'sytlua',
    'prettier',
    'black',
    -- linters
    'luacheck',
    'eslint_d',
    'flake8',
  },
}
