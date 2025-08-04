return {
  {
    'shellRaining/hlchunk.nvim',
    version='v1.3.0',
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
          use_treesitter = false,
        },
        indent = {
          enable = true,
          chars = { '│', '┊' },
          use_treesitter = false,
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
