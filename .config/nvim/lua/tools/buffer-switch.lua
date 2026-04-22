return {
  {
    'toppair/reach.nvim',
    config = function()
      local opts = {
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
      }
      require('reach').setup()

      local TAB = vim.api.nvim_replace_termcodes('<Tab>', true, true, true)

      -- most-recently-used buffer, excluding current; mirrors reach's own
      -- previous-marker selection in buffers/make_buffers.lua
      local function most_recent_bufnr()
        local current = vim.api.nvim_get_current_buf()
        local bufs = vim.tbl_filter(function(b)
          return b.lastused > 0 and b.bufnr ~= current
        end, vim.fn.getbufinfo({ buflisted = 1 }))
        table.sort(bufs, function(a, b)
          return a.lastused > b.lastused
        end)
        return bufs[1] and bufs[1].bufnr
      end

      -- open reach.buffers with first-key interception: <Tab> → most-recent buffer
      local function open_with_tab_select(opts)
        local reach_util = require('reach.util')
        local target = most_recent_bufnr()
        local original = reach_util.pgetcharstr
        local first = true

        reach_util.pgetcharstr = function()
          if not first then
            return original()
          end
          first = false
          local ok, char = pcall(vim.fn.getcharstr)
          if not ok then
            return
          end
          if char == TAB and target then
            vim.schedule(function()
              vim.api.nvim_set_current_buf(target)
            end)
            return
          end
          return char
        end

        local ok, err = pcall(require('reach').buffers, opts)
        reach_util.pgetcharstr = original
        if not ok then
          error(err)
        end
      end

      vim.keymap.set('n', '<Tab>', function()
        open_with_tab_select(opts)
      end, { desc = 'Switch buffers' })
    end,
  },
}
