-- Provides an animated column showing the max line length
return {
  'Bekaboo/deadcolumn.nvim',
  event = 'BufEnter',
  opts = {
    warning = {
      hlgroup = {
        'Warning',
        'background',
      }
    }
  },
}
