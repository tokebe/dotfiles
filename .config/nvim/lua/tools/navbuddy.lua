return {
  'SmiteshP/nvim-navbuddy',
  dependencies = {
    'SmiteshP/nvim-navic',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('nvim-navbuddy').setup({
      window = {
        border = 'single',
        -- win_options = {
        --   winhighlight = 'Normal:Normal,FloatBorder:Normal,FloatTitle:Normal',
        -- },
      },
      size = '80%',
      lsp = {
        auto_attach = true,
        preference = require('config.sources').lsp,
      },
      icons = {
        File = ' ',
        Module = ' ',
        Namespace = ' ',
        Package = '󰏓 ',
        Class = ' ',
        Method = ' ',
        Property = ' ',
        Field = ' ',
        Constructor = ' ',
        Enum = ' ',
        Interface = ' ',
        Function = '󰊕 ',
        Variable = ' ',
        Constant = ' ',
        String = ' ',
        Number = ' ',
        Boolean = ' ',
        Array = ' ',
        Object = '  ',
        Key = '󰌆 ',
        Null = 'ﳠ ',
        EnumMember = ' ',
        Struct = ' ',
        Event = ' ',
        Operator = ' ',
        TypeParameter = ' ',
      },
    })
    vim.g.navic_silence = true -- Suppress errors attaching to lsp
  end,
  keys = {
    {
      '<Leader>fs',
      ':Navbuddy<CR>',
      desc = 'Manage symbols with Navbuddy',
    },
  },
}
