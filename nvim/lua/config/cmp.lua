return {
  config = function(lsp)
    local luasnip = require('luasnip')
    local cmp = require('cmp')

    cmp.setup(lsp.defaults.cmp_config({
      sources = { -- completion sources
        { name = 'nvim_lsp' }, -- language server
        { name = 'nvim_lsp_signature_help' },
        { name = 'luasnip', keyword_length = 2 }, -- snippets
        { name = 'fuzzy_path', options = { fd_timeout_msec = 250 } }, -- filepath
        { name = 'async_path' },
        { name = 'buffer', keyword_length = 3 }, -- current file
      },
      formatting = {
        -- Icons
        format = require('lspkind').cmp_format({
          mode = 'symbol_text',
          maxwidth = 50,
          ellipsis_char = '...',
          before = function(_, vim_item)
            return vim_item -- see lspkind #30
          end,
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
      },
    }))

    -- Use buffer for completion in search
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = { name = 'buffer' },
    })

    -- Cmdline and path completion for commands
    cmp.setup.cmdline(':', {
      sorting = {
        priority_weight = 1,
        comparators = {
          cmp.config.compare.exact,
          cmp.config.compare.offset,
          cmp.config.compare.recently_used,
          cmp.config.compare.score,
          cmp.config.compare.locality,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'cmdline' },
        { name = 'path', group_index = 1 },
        {
          name = 'cmdline_history',
          max_item_count = 3,
          group_index = 2,
        },
        { name = 'zsh' },
      },
    })
  end,
}
