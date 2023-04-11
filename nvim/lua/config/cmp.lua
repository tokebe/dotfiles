return {
  config = function(lsp)
    local luasnip = require('luasnip')
    local cmp = require('cmp')

    cmp.setup(lsp.defaults.cmp_config({
      sources = {                                                -- completion sources
        { name = 'nvim_lsp' },                                   -- language server
        { name = 'nvim_lsp_signature_help' },
        { name = 'luasnip',                keyword_length = 2 }, -- snippets
        { name = 'fuzzy_path' },                                       -- filepath
        { name = 'buffer',                 keyword_length = 3 }, -- current file
      },
      formatting = {
        -- Icons
        format = require('lspkind').cmp_format({
          mode = 'symbol_text',
          maxwidth = 50,
          ellipsis_char = '...',
          before = function(_, vim_item)
            return vim_item -- see lspkind #30
          end
        }),
      },
      mapping = {
        ['<Tab>'] = cmp.mapping(function(fallback)
          if luasnip.expandable() then
            luasnip.expand()
          elseif cmp.visible() then
            cmp.confirm({ select = true })
          else
            fallback()
          end
        end),
        -- ['<Esc>'] = cmp.mapping.abort()
      }
    }))

    -- Use buffer for completion in search
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = { name = 'buffer' }
    })

    -- Cmdline and path completion for commands
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'cmdline' },
        { name = 'fuzzy_path' },
        { name = 'cmdline_history' },
        { name = 'zsh' },
      },
    })
  end
}
