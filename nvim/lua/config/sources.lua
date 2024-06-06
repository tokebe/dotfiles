return {
  lsp = { -- Language Server Protocol
    'lua_ls', -- Lua
    -- 'tsserver', -- Typescript/Javascript
    'pyright', -- Python
    'taplo', -- TOML
    'bashls', -- Bash
    'spectral', -- JSON/YAML
    'marksman', -- Markdown
  },
  dap = { -- Debug Adapter Protocol
    'js',
    -- 'js-debug-adapter', -- VSCode js debug adapter
    -- 'debugpy',
    -- 'bash-debug-adapter',
  },
  formatter = {
    -- formatters
    'sytlua',
    'prettier',
    'black',
    'beautysh',
    -- 'yamlfix',
    'stylua',
    -- linters
    'luacheck',
    'eslint_d',
    'flake8',
    'shellharden',
    'shellcheck',
  },
  treesitter = {
    'dap_repl',
    'regex',
    'markdown_inline',
    'http',
    'json',
    'python',
    'typescript',
    'javascript',
    'latex',
  },
}
