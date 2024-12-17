-- Better Poetry compatibility
require('lspconfig').basedpyright.setup({
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        typeCheckingMode = 'standard',
        useLibraryCodeForTypes = true,
      },
    },
  },
  -- on_attach = function(client, buffer)
  --   client.server_capabilities.hoverProvider = false
  -- end,
  before_init = function(params, config)
    local Path = require('plenary.path')
    local venv = Path:new((config.root_dir:gsub('/', Path.path.sep)), '.venv')

    if venv:joinpath('bin'):is_dir() then
      config.settings.python.pythonPath = tostring(venv:joinpath('bin', 'python'))
    else
      config.settings.python.pythonPath = tostring(venv:joinpath('Scripts', 'python.exe'))
    end
  end,
})
