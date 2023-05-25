return {
  config = function()
    require('nvim-navbuddy').setup({
      window = {
        border = 'none',
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
  end,
}
