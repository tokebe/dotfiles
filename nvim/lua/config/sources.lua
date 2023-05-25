return {
  lsp = { -- Language Server Protocol
    'lua_ls', -- Lua
    'tsserver', -- Typescript/Javascript
    'pyright', -- Python
    'taplo', -- TOML
    'bashls', -- Bash
    'spectral', -- JSON/YAML
    'marksman', -- Markdown
  },
  dap = { -- Debug Adapter Protocol
    'node-debug2-adapter',
    'debugpy',
    'bash-debug-adapter',
  },
  formatter = {
    -- formatters
    'sytlua',
    'prettier',
    'black',
    'beautysh',
    'yamlfix',
    'stylua',
    -- linters
    'luacheck',
    'eslint_d',
    'flake8',
    'shellharden',
  },
}
