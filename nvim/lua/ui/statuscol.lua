return {
  {
    'luukvbaal/statuscol.nvim',
    -- commit = 'd9ee308',
    config = function()
      local builtin = require('statuscol.builtin')

      vim.opt.fillchars = {
        foldopen = '',
        foldclose = '',
        foldsep = ' ',
        eob = ' ',
      }
      vim.api.nvim_create_autocmd({ 'FileType' }, {
        callback = function()
          local filetype_excludes = require('config.filetype_excludes')
          for i, value in ipairs(filetype_excludes) do
            if vim.bo.filetype == value then
              return
            end
          end
          require('statuscol').setup({
            relculright = true,
            ft_ignore = require('config.filetype_excludes'),
            segments = {
              {
                sign = { name = { 'Diagnostic', 'todo.*' }, maxwidth = 2, colwidth = 2, auto = false },
                click = 'v:lua.ScSa',
              },
              {
                sign = { name = { 'Breakpoint' }, maxwidth = 2, colwidth = 2, auto = true },
                click = 'v:lua.ScSa',
              },
              { text = { builtin.lnumfunc }, click = 'v:lua.ScLa' },
              {
                sign = { name = { '.*' }, maxwidth = 1, colwidth = 1, auto = false },
                click = 'v:lua.ScSa',
              },
              { text = { builtin.foldfunc, ' ' }, click = 'v:lua.ScFa' },
            },
          })
        end,
      })
    end,
  },
}