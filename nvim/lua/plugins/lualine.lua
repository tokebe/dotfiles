return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'kosayoda/nvim-lightbulb',
  },
  config = function()
    local function show_macro_recording()
      local recording_register = vim.fn.reg_recording()
      if recording_register == '' then
        return ''
      else
        return 'Recording @' .. recording_register
      end
    end

    local function get_lightbulb()
      return require('nvim-lightbulb').get_status_text()
    end

    local function get_term_num()
      local num = vim.b.toggle_number
      if vim.bo.filetype == 'toggleterm' and string.len(num) > 0 then
        return '  ' .. num
      else
        return ''
      end
    end

    require('lualine').setup({
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '╱', right = '╱' },
        section_separators = { left = '', right = '' },
        globalstatus = true,
      },
      sections = {
        lualine_a = { 'mode', get_term_num },
        lualine_b = {
          'branch',
          {
            'diff',
            colored = true,
            symbols = { added = ' ', modified = ' ', removed = ' ' },
          },
          'diagnostics',
          get_lightbulb,
        },
        lualine_c = {
          show_macro_recording,
          { require('noice').api.status.search.get, cond = require('noice').api.status.search.has },
        },
        lualine_x = { 'overseer', 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      tabline = {
        lualine_a = {
          {
            'buffers',
            use_mode_colors = true,
            symbols = {
              modified = ' 󰏫 ',
              alternate_file = '',
              directory = ' ',
            },
          },
        },
        lualine_z = { { 'tabs', mode = 1, use_mode_colors = true, } },
      },
    })
  end,
}
