return {
  'luukvbaal/statuscol.nvim',
  commit = 'd9ee308',
  config = function()
    local builtin = require('statuscol.builtin')

    vim.opt.fillchars = {
      foldopen = '˅',
      foldclose = '˃',
      foldsep = ' ',
    }

    require('statuscol').setup({
      relculright = true,
      segments = {
        {
          sign = { name = { 'Diagnostic' }, maxwidth = 2, colwidth = 1, auto = false },
          click = 'v:lua.ScSa',
        },
        { text = { builtin.lnumfunc }, click = 'v:lua.ScLa'},
        {
          sign = { name = { '.*' }, maxwidth = 1, colwidth = 1, auto = true },
          click = 'v:lua.ScSa',
        },
        { text = { builtin.foldfunc, ' ' }, click = 'v:lua.ScFa' },
      },
    })
  end,
}
