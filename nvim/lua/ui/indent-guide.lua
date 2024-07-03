return {
  -- {
  --   -- Add indentation guides even on blank lines
  --   'lukas-reineke/indent-blankline.nvim',
  --   event = 'BufEnter',
  --   config = function()
  --     local highlight = {
  --       'CursorColumn',
  --       'Whitespace',
  --     }
  --     require('ibl').setup({
  --       indent = {
  --         char = '│',
  --         -- char = '',
  --         -- highlight = highlight,
  --       },
  --       whitespace = {
  --         -- highlight = highlight,
  --       },
  --       exclude = {
  --         filetypes = require('config.filetype_excludes'),
  --       },
  --     })
  --   end,
  -- },
  {
    'shellRaining/hlchunk.nvim',
    event = { 'UIEnter' },
    config = function()
      require('hlchunk').setup({
        chunk = {
          enable = true,
          chars = {
            right_arrow = '─',
          },
          use_treesitter = true,
        },
        indent = {
          enable = true,
          chars = { '│', '┊' },
          use_treesitter = true,
        },
        line_num = {
          enable = true,
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
