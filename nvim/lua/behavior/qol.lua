local util = require('util')
return {
  { -- Intelligent paste indenting. Not treesitter-intelligent; doesn't work on .py etc.
    'ku1ik/vim-pasta',
  },
  {               -- d deletes instead of cuts, D now cuts
    'gbprod/cutlass.nvim',
    lazy = false, -- Doesn't seem to bind keys without this
    config = function()
      require('cutlass').setup({
        cut_key = 'D',
        exclude = { 'ns', 'nS' }, -- Avoid conflict with lightspeed.nvim
        registers = {
          select = 's',
          delete = 'd',
          change = 'c',
        },
      })
    end,
  },
  { -- Delete buffers but preserve window layout
    'ojroques/nvim-bufdel',
    config = function()
      require('bufdel').setup({
        quit = false,
      })
      util.keymap('n', '<Leader>wq', ':BufDel<CR>', {
        desc = 'Close buffer',
      })
      util.keymap('n', '<Leader>wQ', ':BufDel!<CR>', {
        desc = 'Close buffer (force)',
      })
      util.keymap('n', '<Leader>wa', ':BufDelAll<CR>', {
        desc = "Close all buffers"
      })
      util.keymap('n', '<Leader>wA', ':BufDelAll!<CR>', {
        desc = "Close all buffers (force)"
      })
      util.keymap('n', '<Leader>wo', ':BufDelOthers<CR>', {
        desc = "Close all other buffers"
      })
      util.keymap('n', '<Leader>wO', ':BufDelOthers!<CR>', {
        desc = "Close all other buffers (force)"
      })
    end,
  },
  { -- Autosave on text changed
    'Pocco81/auto-save.nvim',
    config = function()
      require('auto-save').setup({
        -- trigger_events = { 'InsertLeave' }
        debounce_delay = 500,
      })

      util.keymap('n', '<Leader>oa', ':ASToggle<CR>', {
        desc = 'Toggle autosave',
      })
    end,
  },
  {
    'willothy/flatten.nvim',
    opts = {
      window = {
        open = 'alternate',
      },
      callbacks = {
        should_block = function(argv)
          -- Note that argv contains all the parts of the CLI command, including
          -- Neovim's path, commands, options and files.
          -- See: :help v:argv

          -- In this case, we would block if we find the `-b` flag
          -- This allows you to use `nvim -b file1` instead of `nvim --cmd 'let g:flatten_wait=1' file1`
          return vim.tbl_contains(argv, '-b')

          -- Alternatively, we can block if we find the diff-mode option
          -- return vim.tbl_contains(argv, "-d")
        end,
        post_open = function(bufnr, winnr, ft, is_blocking)
          if is_blocking then
            -- Hide the terminal while it's blocking
            require('toggleterm').toggle(0)
          else
            -- If it's a normal file, just switch to its window
            vim.api.nvim_set_current_win(winnr)
          end

          -- If the file is a git commit, create one-shot autocmd to delete its buffer on write
          -- If you just want the toggleable terminal integration, ignore this bit
          if ft == 'gitcommit' then
            vim.api.nvim_create_autocmd('BufWritePost', {
              buffer = bufnr,
              once = true,
              callback = function()
                -- This is a bit of a hack, but if you run bufdelete immediately
                -- the shell can occasionally freeze
                vim.defer_fn(function()
                  vim.api.nvim_buf_delete(bufnr, {})
                end, 50)
              end,
            })
          end
        end,
        block_end = function()
          -- After blocking ends (for a git commit, etc), reopen the terminal
          require('toggleterm').toggle(0)
        end,
      },
    },
  },
  {
    'echasnovski/mini.basics',
    config = function()
      require('mini.basics').setup({
        options = {
          basic = false,
          extra_ui = false,
          win_borders = 'double',
        },
        mappings = {
          basic = true,
          option_toggle_prefix = [[<Leader>o]],
          windows = true,
          move_with_alt = true,
        },
        autocommands = {
          basic = true,
          relnum_in_visual_mode = true,
        },
      })
    end,
  },
  {
    'echasnovski/mini.move',
    config = function()
      require('mini.move').setup()
    end,
  },
  { -- Automatic intelligent tab size detection
    'tpope/vim-sleuth',
  },
  {
    'christoomey/vim-tmux-navigator',
    lazy = false,
  },
  {
    'chrisgrieser/nvim-early-retirement',
    event = 'VeryLazy',
    config = function()
      require('early-retirement').setup({
        ignoredFileTypes = require('config.filetype_excludes'),
        minimumBufferNum = 10,
        notificationOnAutoClose = true,
      })
    end,
  },
  -- { -- Substitution is broken
  --   'ZSaberLv0/eregex.vim',
  --   lazy = false,
  -- },
}
