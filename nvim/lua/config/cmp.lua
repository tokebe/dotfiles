return {
  config = function(lsp)
    local luasnip = require('luasnip')
    local cmp = require('cmp')

    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
    end

    local cmp_autopairs = require('nvim-autopairs.completion.cmp')

    cmp.setup(lsp.defaults.cmp_config({
      sources = { -- completion sources
        { name = 'nvim_lsp' }, -- language server
        -- { name = 'nvim_lsp_signature_help' },
        { name = 'luasnip', keyword_length = 2 }, -- snippets
        { name = 'fuzzy_path', options = { fd_timeout_msec = 250 } }, -- filepath
        { name = 'async_path' },
        { name = 'buffer', keyword_length = 3 }, -- current file
      },
      view = {
        entries = { selection_order = 'near_cursor' }
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
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          -- elseif has_words_before() then
          --   cmp.complete()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<CR>'] = cmp.mapping({
          i = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({ select = false })
            else
              fallback()
            end
          end,
          s = cmp.mapping.confirm({ select = true }),
        }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
    }))

    -- Autopair after function/selection
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

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
