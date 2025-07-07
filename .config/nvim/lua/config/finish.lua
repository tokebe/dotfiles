-- Do anything that should be done last

-- Configure diagnostics
require('config.diagnostics')

-- Ensure diff fill is a connecting slash
-- Among other fillchars
vim.opt.fillchars:append({
  eob = ' ',
  diff = '╱',
  horiz = '━',
  horizup = '┻',
  horizdown = '┳',
  vert = '┃',
  vertleft = '┫',
  vertright = '┣',
  verthoriz = '╋',
})
