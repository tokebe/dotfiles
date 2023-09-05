local util = require('util')
return {
  'rest-nvim/rest.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('rest-nvim').setup({
      -- result_split_horizontal = true,
      result_split_in_place = true,
      result = {
        show_url = true,
        show_curl_command = false,
      },
    })
    util.keymap('n', '<Leader>rh', '<Plug>RestNvim', { desc = 'Run http request under cursor' })
    util.keymap('n', '<Leader>rp', '<Plug>RestNvimPreview', { desc = 'Preview cURL command for request' })
    util.keymap('n', '<Leader>r.', '<Plug>RestNvimLast', { desc = 'Re-run last http request' })
  end,
}
