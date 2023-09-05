local M = {}

M.get_cwd_as_name = function()
  local dir = vim.fn.getcwd(0)
  return dir:gsub('[^A-Za-z0-9]', '_')
end

M.copy_table = function(table)
  local table_copy = {}
  for k, v in pairs(table) do
    table_copy[k] = v
  end
  return table_copy
end

M.keymap = function(modes, lhs, rhs, opts)
  if opts == nil then
    vim.keymap.set(modes, lhs, rhs)
    return
  end
  local keymap = {}
  local key_opts = M.copy_table(opts)
  key_opts.mode = modes
  key_opts.desc = nil
  -- if opts.desc ~= nil then
  --   key_opts.insert(1, )
  -- end
  table.insert(keymap, rhs)
  if opts.desc ~= nil or opts.description ~= nil then
    table.insert(keymap, opts.desc or opts.description or 'MISSING DESC')
    -- key_opts.name = opts.desc
  end
  require('which-key').register({
    [lhs] = keymap,
  }, key_opts)
end

return M
