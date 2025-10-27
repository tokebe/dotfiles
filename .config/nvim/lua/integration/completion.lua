return {
  {
    'saghen/blink.cmp',
    dependencies = {
      { 'saghen/blink.compat', version = '2.*', lazy = true, opts = {} },
      { 'L3MON4D3/LuaSnip', version = 'v2.*', build = 'make install_jsregexp' },
      'rafamadriz/friendly-snippets',
    },
    version = '1.*',
    config = function()
      -- TODO: DAP REPL completion
      vim.api.nvim_set_hl(0, 'BlinkCmpLabelMatch', { bold = true })
      require('blink.cmp').setup({
        keymap = {
          preset = 'enter',
          ['<C-k>'] = { 'show', 'fallback' },
          ['<Tab>'] = {
            function(cmp)
              if cmp.snippet_active() then
                return cmp.accept()
              elseif cmp.is_menu_visible() then
                return cmp.select_next()
              end
            end,
            'fallback',
          },
          ['<S-Tab>'] = {
            function(cmp)
              if cmp.snippet_active() then
                return cmp.snippet_backward()
              elseif cmp.is_menu_visible() then
                return cmp.select_prev()
              end
            end,
            'fallback',
          },
        },
        appearance = {
          nerd_font_variant = 'mono',
        },
        completion = {
          keyword = { range = 'full' },
          trigger = {
            show_on_backspace_in_keyword = true,
          },
          list = {
            selection = {
              preselect = false,
            },
          },
          menu = {
            min_width = 20,
            -- border = 'solid',
            draw = {
              -- We don't need label_description now because label and label_description are already
              -- combined together in label by colorful-menu.nvim.
              gap = 2,
              columns = { { 'kind_icon' }, { 'label', gap = 1 } },
              components = {
                label = {
                  width = { fill = true, max = 60 },
                  text = function(ctx)
                    local highlights_info = require('colorful-menu').blink_highlights(ctx)
                    if highlights_info ~= nil then
                      -- Or you want to add more item to label
                      return highlights_info.label
                    else
                      return ctx.label
                    end
                  end,
                  highlight = function(ctx)
                    local highlights = {}
                    local highlights_info = require('colorful-menu').blink_highlights(ctx)
                    if highlights_info ~= nil then
                      highlights = highlights_info.highlights
                    end
                    for _, idx in ipairs(ctx.label_matched_indices) do
                      table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
                    end
                    -- Do something else
                    return highlights
                  end,
                },
              },
            },
          },
          documentation = {
            auto_show = true,
          },
          ghost_text = { enabled = true },
        },
        sources = {
          default = { 'lsp', 'lazydev', 'snippets', 'path', 'buffer' },
          providers = {
            lazydev = {
              name = 'lazydev',
              module = 'blink.compat.source',
              opts = {
                group_index = 0,
              },
            },
          },
        },
        snippets = { preset = 'luasnip' },
        signature = { enabled = false },
        fuzzy = { implementation = 'prefer_rust_with_warning' },
        cmdline = {
          keymap = {
            preset = 'cmdline',
            ['<C-k>'] = { 'show', 'fallback' },
            ['<CR>'] = {
              function(cmp)
                if cmp.is_menu_visible() then
                  return cmp.accept()
                end
              end,
              'fallback',
            },
            ['<Esc>'] = {
              function(cmp)
                if cmp.is_menu_visible() then
                  return cmp.cancel()
                else
                  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, true, true), 'n', true)
                end
              end,
            },
          },
          completion = { ghost_text = { enabled = false } },
        },
      })
    end,
    opts_extend = { 'sources.default' },
  },
}
