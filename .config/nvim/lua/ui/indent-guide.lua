return {
  {
    'shellRaining/hlchunk.nvim',
    event = { 'UIEnter' },
    config = function()
      require('hlchunk').setup({
        chunk = {
          enable = true,
          chars = {
            right_arrow = '─',
            left_top = '┌',
            left_bottom = '└',
          },
          use_treesitter = true,
        },
        indent = {
          enable = true,
          chars = { '│', '┊' },
          use_treesitter = true,
        },
        line_num = {
          enable = false,
        },
        blank = {
          enable = false,
          chars = {
            '░',
            ' ',
          },
        },
      })
    end,
  },
}
