return {
  config = function()
    local luasnip = require('luasnip')
    local cmp = require('cmp')

    require('luasnip.loaders.from_vscode').lazy_load()

    local cmp_autopairs = require('nvim-autopairs.completion.cmp')

    cmp.setup({
      window = {
        completion = { border = 'solid' },
        documentation = { border = 'solid' },
      },
      -- enabled = function()
      --   return vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt' or require('cmp_dap').is_dap_buffer()
      -- end,
      sources = { -- completion sources
        { name = 'nvim_lsp' }, -- language server
        { name = 'lazydev', group_index = 0 },
        -- { name = 'nvim_lsp_signature_help' },
        { name = 'luasnip', keyword_length = 2 }, -- snippets
        { name = 'fuzzy_path', options = { fd_timeout_msec = 250 } }, -- filepath
        { name = 'async_path' },
        { name = 'buffer', keyword_length = 3 }, -- current file
      },
      view = {
        entries = { name = 'custom', selection_order = 'near_cursor', follow_cursor = false },
      },
      formatting = {
        expandable_indicator = true,
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
          local kind = require('lspkind').cmp_format({
            mode = 'symbol_text',
          })(entry, vim.deepcopy(vim_item))
          local highlights_info = require('colorful-menu').cmp_highlights(entry)

          -- if highlight_info==nil, which means missing ts parser, let's fallback to use default `vim_item.abbr`.
          -- What this plugin offers is two fields: `vim_item.abbr_hl_group` and `vim_item.abbr`.
          if highlights_info ~= nil then
            vim_item.abbr_hl_group = highlights_info.highlights
            vim_item.abbr = highlights_info.text
          end
          local strings = vim.split(kind.kind, '%s', { trimempty = true })
          vim_item.kind = ' ' .. (strings[1] or '') .. ' '
          vim_item.menu = entry.source.name

          return vim_item
        end,
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
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
    })

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
    -- DAP REPL
    cmp.setup.filetype({ 'dap-repl', 'dapui_watches', 'dapui_hover' }, {
      sources = {
        { name = 'dap' },
      },
    })
  end,
}
