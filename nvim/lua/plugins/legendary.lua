-- Make Esc hide search highlight in normal mode
vim.api.nvim_set_keymap('n', '<Esc>', ':noh<CR>', { noremap = true, silent = true })
return {
  'mrjones2014/legendary.nvim',
  config = function()
    require('legendary').setup({
      keymaps = {
        {
          '<leader>gf',
          {
            n = function()
              vim.lsp.buf.format({ async = true })
            end,
            v = function()
              vim.lsp.buf.format({
                async = true,
                range = {
                  ['start'] = vim.api.nvim_buf_get_mark(0, '<'),
                  ['end'] = vim.api.nvim_buf_get_mark(0, '>'),
                }
              })
            end
          },
          description = 'Format'
        },
      },
      commands = {},
      funcs = {},
      autocmds = {},
      extensions = {},
      col_separator_char = ' ',
      which_key = {
        auto_register = true,
      },
    })
  end
}
