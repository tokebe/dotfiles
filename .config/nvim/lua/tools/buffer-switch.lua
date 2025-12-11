return {
  -- TODO: fork and make a PR for tab for most recent behavior
  {
    'toppair/reach.nvim',
    config = function()
      local reach = require('reach')
      reach.setup()
      vim.keymap.set('n', '<Tab>', function()
        reach.buffers({
          handle = 'dynamic',
          modified_icon = ' 󰏫 ',
          previous = {
            enabled = true,
            depth = 2,
            chars = { '󰋚' },
          },
          actions = {
            split = ';',
            vertsplit = "'",
            delete = '<Backspace>',
          },
        })
      end, { desc = 'Switch buffers' })
      -- vim.keymap.set('n', '<Tab>', ':b#<CR>')
    end,
  },
  -- { -- Very cool plugin, come back to it in a few months
  --   'ahkohd/buffer-sticks.nvim',
  --   event = 'VeryLazy',
  --   keys = {
  --     {
  --       '<Tab>',
  --       function()
  --         BufferSticks.jump()
  --       end,
  --     },
  --   },
  --   config = function()
  --     local sticks = require('buffer-sticks')
  --     sticks.setup({
  --       filter = {
  --         filetypes = require('config.filetype_excludes'),
  --       },
  --       offset = {
  --         x = 1,
  --       },
  --       preview = {
  --         float = {
  --           height = 0.3,
  --         },
  --       },
  --     })
  --     sticks.show()
  --   end,
  -- },
}
