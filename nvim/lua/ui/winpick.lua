return {
  {
    'gbrlsnchs/winpick.nvim',
    config = function()
      local winpick = require('winpick')
      winpick.setup()
      vim.keymap.set('n', '<Leader>fw', function()
        local winid = winpick.select()
        if winid then
          vim.api.nvim_set_current_win(winid)
        end
      end)
    end,
  },
}
