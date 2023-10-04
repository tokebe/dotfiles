local util = require('util')
return {
  {
    'rest-nvim/rest.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('rest-nvim').setup({
        -- result_split_horizontal = true,
        result_split_in_place = true,
        encode_url = false,
        result = {
          show_url = true,
          show_curl_command = false,
        },
        highlight = {
          enabled = true,
          timeout = 150,
        },
      })
      util.keymap('n', '<Leader>uu', '<Plug>RestNvim', { desc = 'Run http request under cursor' })
      util.keymap('n', '<Leader>up', '<Plug>RestNvimPreview', { desc = 'Preview cURL command for request' })
      util.keymap('n', '<Leader>u.', '<Plug>RestNvimLast', { desc = 'Re-run last http request' })
    end,
  },
  -- {
  --   'BlackLight/nvim-http',
  --   config = function()
  --     util.keymap('n', '<Leader>uu', '<CMD>Http<CR>', { desc = 'Run http request under cursor' })
  --     util.keymap('n', '<Leader>us', '<CMD>HttpStop<CR>', { desc = 'Stop current http request' })
  --   end,
  -- },
}
