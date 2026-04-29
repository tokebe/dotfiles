return {
  { -- To be enabled when latest stable neovim supports it
    'Bekaboo/dropbar.nvim',
    config = function()
      require('dropbar').setup({
        menu = {
          preview = false,
        },
      })
    end,
  },
  {
    'b0o/incline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'lewis6991/gitsigns.nvim' },
    config = function()
      local helpers = require('incline.helpers')
      local devicons = require('nvim-web-devicons')
      require('incline').setup({
        ignore = {
          filetypes = require('config.filetype_excludes'),
        },
        window = {
          overlap = {
            borders = true,
            winbar = true,
          },
          padding = 0,
          margin = { horizontal = 0, vertical = 0 },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
          if filename == '' then
            filename = '[No Name]'
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          return {
            ft_icon and { ' ', ft_icon, ' ', guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or '',
            ' ',
            { filename, gui = modified and 'bold,italic' or 'bold' },
            ' ',
            guibg = '#44406e',
          }
        end,
      })
    end,
    -- Optional: Lazy load Incline
    event = 'VeryLazy',
  },
}
