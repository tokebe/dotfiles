return {
  {
    'anuvyklack/windows.nvim',
    dependencies = {
      'anuvyklack/middleclass',
      -- 'anuvyklack/animation.nvim',
    },
    config = function()
      vim.o.winwidth = 15
      vim.o.winminwidth = 15
      vim.o.equalalways = false
      require('windows').setup({
        autowidth = {
          winwidth = 1.5,
        },
        animation = {
          duration = 150,
        },
      })

      vim.keymap.set('n', '<Leader>ww', ':WindowsMaximize<CR>', {
        desc = 'Maximize current window',
      })
      vim.keymap.set('n', '<Leader>we', ':WindowsEqualize<CR>', {
        desc = 'Equalize windows',
      })
      vim.keymap.set('n', '<Leader>wW', ':WindowsToggleAutowidth<CR>', {
        desc = 'Toggle window autowidth',
      })
      vim.keymap.set('n', '<Leader>wh', ':WindowsMaximizeHorizontally<CR>', {
        desc = 'Maximize window horizontally',
      })
      vim.keymap.set('n', '<Leader>wv', ':WindowsMaximizeVertically<CR>', {
        desc = 'Maximize window vertically',
      })
    end,
  },
  {
    'gbrlsnchs/winpick.nvim',
    config = function()
      local winpick = require('winpick')
      winpick.setup({
        border = 'solid',
      })
      vim.keymap.set('n', '<Leader>sw', function()
        local winid = winpick.select()
        if winid then
          vim.api.nvim_set_current_win(winid)
        end
      end, { desc = 'Select a window' })
    end,
  },
  {
    'nvim-zh/colorful-winsep.nvim',
    event = { 'WinLeave' },
    config = function()
      require('colorful-winsep').setup({
        symbols = { '─', '│', '┌', '┐', '└', '┘' },
        -- no_exec_files = require('config.filetype_excludes'),
        no_exec_files = {
          'telescopePrompt',
          'TelescopeResults',
          'DressingSelect',
          'mason',
          'null-ls-info',
          'lazy',
          'lspinfo',
          'WhichKey',
          'dashboard',
          'dashboardpreview',
        },
      })
    end,
  },
}
