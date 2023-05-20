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

    require('lualine').setup({
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '╱', right = '╱' },
        section_separators = { left = '', right = '' },
        globalstatus = true,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics', get_lightbulb },
        lualine_c = { show_macro_recording, 'selectioncount' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
    })
  end,
}
