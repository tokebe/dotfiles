-- Do anything that should be done last

-- Ensure diff fill is a connecting slash
vim.opt.fillchars:append({
  diff = '╱',
})
