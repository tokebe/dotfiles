return {
  { -- Pipe buffer to command, command back to buffer
    'jake-stewart/pipe.nvim',
    config = function()
      require('pipe').setup()
    end,
  },
}

