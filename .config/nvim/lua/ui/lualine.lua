local util = require('util')
return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'tiagovla/scope.nvim',
      'stevearc/overseer.nvim',
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

      local function get_term_num()
        local num = vim.b.toggle_number
        if vim.bo.filetype == 'toggleterm' and string.len(num) > 0 then
          return '  ' .. num
        else
          return ''
        end
      end

      local function get_pwd_folder()
        local Path = require('plenary.path')
        local pwd = Path:new(vim.fn.getcwd())
        local i = pwd:_split()
        return ' ' .. pwd:_split()[#i]
      end

      require('lualine').setup({
        options = {
          icons_enabled = true,
          theme = 'auto',
          -- component_separators = { left = '╱', right = '╱' },
          -- section_separators = { left = '', right = '' },
          -- component_separators = { left = '│', right = '│' },
          -- section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          globalstatus = true,
        },
        sections = {
          lualine_a = { { 'mode', icons_enabled = true }, get_term_num },
          lualine_b = {
            get_pwd_folder,
            'branch',
            {
              'diff',
              colored = true,
              symbols = { added = '󰐙 ', modified = '󰪥 ', removed = '󰍷 ' },
            },
            {
              'diagnostics',
              symbols = { error = ' ', warn = ' ', info = ' ', hint = '󱉵 ' },
              update_in_insert = false,
            },
          },
          lualine_c = {
            -- show_macro_recording,
            -- require('NeoComposer.ui').status_recording,
            { require('noice').api.status.search.get, cond = require('noice').api.status.search.has },
          },
          lualine_x = { 'overseer' },
          lualine_y = { 'encoding', 'fileformat', 'filetype', 'progress' },
          lualine_z = { 'location' },
        },
        tabline = {
          lualine_a = {
            {
              'buffers',
              fmt = function(str, self)
                -- TODO: probably able to do a unique here
                -- would have to look at all other buffers in tab
                -- and then traverse up parent dir until strings do not match
                return str
              end,
              use_mode_colors = true,
              symbols = {
                modified = ' 󰏫 ',
                alternate_file = '',
                directory = ' ',
              },
            },
          },
          lualine_z = { { 'tabs', mode = 0, use_mode_colors = true, symbols = { modified = ' 󰏫 ' } } },
        },
      })

      require('scope').setup({})

      vim.keymap.set('n', '<Leader>wr', ':LualineTabRename ', {
        desc = 'Rename current tabpage',
      })
    end,
  },
}
