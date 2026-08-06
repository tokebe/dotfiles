return {
  {
    'tadmccorkle/markdown.nvim',
    ft = 'markdown',
    opts = {},
  },
  {
    'OXY2DEV/markview.nvim',
    -- markview lazy-loads itself; don't drive it with `ft`/`event`.
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      preview = {
        -- mirrors render-markdown `file_types`
        filetypes = { 'markdown', 'quarto', 'rmd' },
        -- mirrors render-markdown `render_modes = { 'n', 'c', 'i' }`
        modes = { 'n', 'c', 'i' },

        -- Anti-conceal behaviour: keep everything previewed except the
        -- element the cursor sits inside, which falls back to raw markdown
        -- so it's editable. Node-wise (not line-wise) so that whole blocks
        -- de-render when entered -- notably code blocks show their full raw
        -- source (fences + code) instead of just the cursor line.
        --   hybrid_modes        -> partial preview applies in these modes
        --   linewise_hybrid_mode = false -> de-render whole nodes, not lines
        --   edit_range = { 0, 0 } -> anchor on the cursor line (0 above / 0 below);
        --                            the node containing it is cleared entirely
        hybrid_modes = { 'n', 'c', 'i' },
        linewise_hybrid_mode = false,
        edit_range = { 0, 0 },

        icon_provider = 'devicons',
      },
      markdown = {
        headings = {
          enable = true,
          -- render-markdown does not indent heading text per level
          shift_width = 0,
          -- Label (bar) style + block-glyph icons approximates render-markdown's
          -- `width = 'block'` headings with the `█`/`██`/... icons.
          heading_1 = { style = 'label', align = 'left', hl = 'MarkviewHeading1', icon = '█ ', icon_hl = 'MarkviewHeading1Sign', padding_right = ' ' },
          heading_2 = { style = 'label', align = 'left', hl = 'MarkviewHeading2', icon = '██ ', icon_hl = 'MarkviewHeading2Sign', padding_right = ' ' },
          heading_3 = { style = 'label', align = 'left', hl = 'MarkviewHeading3', icon = '███ ', icon_hl = 'MarkviewHeading3Sign', padding_right = ' ' },
          heading_4 = { style = 'label', align = 'left', hl = 'MarkviewHeading4', icon = '████ ', icon_hl = 'MarkviewHeading4Sign', padding_right = ' ' },
          heading_5 = { style = 'label', align = 'left', hl = 'MarkviewHeading5', icon = '█████ ', icon_hl = 'MarkviewHeading5Sign', padding_right = ' ' },
          heading_6 = { style = 'label', align = 'left', hl = 'MarkviewHeading6', icon = '██████ ', icon_hl = 'MarkviewHeading6Sign', padding_right = ' ' },
        },
        code_blocks = {
          enable = true,
          -- 'simple' rather than 'block'. Block style pads every line out to a
          -- fixed block width with no cap at the window edge, so a single long
          -- code line forces the whole block wider -- and with `wrap` on, every
          -- line in the block then wraps (a cascade of tiny wrap-lines). Simple
          -- style just draws full-width background bars with no fixed width, so
          -- only a genuinely over-long line wraps, on its own line.
          -- (min_width / pad_amount / pad_char are block-only; N/A here.)
          style = 'simple',
          -- render-markdown `position = 'right'`
          label_direction = 'right',
          border_hl = 'MarkviewCode',
          info_hl = 'MarkviewCodeInfo',
          sign = true,
        },
        tables = {
          enable = true,
          -- draw top/bottom borders on dedicated virtual lines instead of
          -- overlapping the lines around the table
          use_virt_lines = true,
          block_decorator = true,
          strict = false,
        },
      },
    },
  },
  -- Previous in-buffer renderer, kept for easy revert.
  -- {
  --   'MeanderingProgrammer/render-markdown.nvim',
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter',
  --     'nvim-tree/nvim-web-devicons',
  --   },
  --   event = {
  --     'FileType',
  --   },
  --   opts = {
  --     file_types = {
  --       'markdown',
  --       'quarto',
  --       'rmd',
  --     },
  --     render_modes = { 'n', 'c', 'i' },
  --     heading = {
  --       width = 'block',
  --       min_width = 88,
  --       below = '▔',
  --       above = '▁',
  --       icons = {
  --         '█ ',
  --         '██ ',
  --         '███ ',
  --         '████ ',
  --         '█████ ',
  --         '██████ ',
  --       },
  --       border = true,
  --     },
  --     code = {
  --       position = 'right',
  --       language_pad = 1,
  --       width = 'block',
  --       min_width = 88,
  --       border = 'thick',
  --     },
  --   },
  -- },
}
