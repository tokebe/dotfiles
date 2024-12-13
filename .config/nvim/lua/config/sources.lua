return {
  lsp = {           -- Language Server Protocol
    'lua_ls',       -- Lua
    -- 'tsserver', -- Typescript/Javascript
    'basedpyright', -- Python
    'ruff',         --Python
    'taplo',        -- TOML
    'bashls',       -- Bash
    'spectral',     -- JSON/YAML
    'marksman',     -- Markdown
  },
  dap = {           -- Debug Adapter Protocol
    'js',
    -- 'js-debug-adapter', -- VSCode js debug adapter
    -- 'debugpy',
    -- 'bash-debug-adapter',
  },
  formatter = {
    -- formatters
    'sytlua',
    -- 'prettierd', -- Better to use dedicated formatters
    -- 'black', -- Replaced by Ruff
    'beautysh',
    'yamlfix',
    'stylua',
    -- linters
    'luacheck',
    'eslint_d',
    'ruff',
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
