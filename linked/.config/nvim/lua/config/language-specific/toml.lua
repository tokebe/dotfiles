-- taplo LSP skips the project .taplo.toml (its `exclude` is only for the CLI's `taplo format`),
-- so in-editor it formats every TOML — excluded ones included — with taplo's formatting config.
vim.lsp.config('taplo', {
  cmd = { 'taplo', 'lsp', '--no-auto-config', 'stdio' },
})
