local util = require('util')
return {
  { -- Intelligent paste indenting. Not treesitter-intelligent; doesn't work on .py etc.
    'ku1ik/vim-pasta',
  },
  {
    'tenxsoydev/karen-yank.nvim',
    config = function()
      require('karen-yank').setup()
    end,
  },
  {
    'ptdewey/yankbank-nvim',
    config = function()
      require('yankbank').setup({
        max_entries = 10,
      })
      vim.keymap.set('n', '<Leader>sy', '<CMD>YankBank<CR>', { noremap = true, desc = 'Select & paste from clipboard' })
    end,
  },
  {
    'folke/snacks.nvim',
    priority = 9999,
    lazy = false,
    config = function()
      local snacks = require('snacks')
      snacks.setup({
        quickfile = { enabled = true },
        bigfile = { enabled = true },
        -- Disabled because it causes weird interactions with cmp that move the cursor
        -- scroll = { enabled = true, animate = { duration = { total = 200 } } },
        indent = {
          filter = function(buf)
            local excludes = require('config.filetype_excludes')
            local is_excluded = false
            for i, v in ipairs(excludes) do
              if v == vim.bo[buf].buftype then
                is_excluded = true
              end
            end
            return is_excluded ~= false
              and vim.g.snacks_indent ~= false
              and vim.b[buf].snacks_indent ~= false
              and vim.bo[buf].buftype == ''
          end,
          indent = {
            enabled = true,
            priority = 510,
          },
          animate = {
            duration = {
              total = 300,
            },
          },
          chunk = {
            enabled = true,
            priority = 511,
            only_current = true,
            char = {
              arrow = '─',
            },
            hl = 'SnacksIndentScope',
          },
        },
      })

      -- file rename with lsp
      vim.keymap.set('n', '<Leader>rf', snacks.rename.rename_file, { desc = 'Rename file using LSP' })

      -- profiling
      snacks.toggle.profiler():map('<Leader>pt')
      snacks.toggle.profiler_highlights():map('<Leader>ph')
      vim.keymap.set('n', '<Leader>po', snacks.profiler.scratch, { desc = 'Profiler scratch buffer' })

      -- bufdel
      vim.keymap.set('n', '<Leader>wq', function()
        snacks.bufdelete()
      end, {
        desc = 'Close buffer',
      })
      vim.keymap.set('n', '<Leader>wQ', function()
        snacks.bufdelete({ force = true })
      end, {
        desc = 'Close buffer (force)',
      })
      vim.keymap.set('n', '<Leader>wa', function()
        snacks.bufdelete.all()
      end, {
        desc = 'Close all buffers',
      })
      vim.keymap.set('n', '<Leader>wA', function()
        snacks.bufdelete.all({ force = true })
      end, {
        desc = 'Close all buffers (force)',
      })
      vim.keymap.set('n', '<Leader>wo', function()
        snacks.bufdelete.other()
      end, {
        desc = 'Close all other buffers',
      })
      vim.keymap.set('n', '<Leader>wO', function()
        snacks.bufdelete.other({ force = true })
      end, {
        desc = 'Close all other buffers (force)',
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

      vim.keymap.set('n', '<Leader>ota', ':ASToggle<CR>', {
        desc = 'Toggle autosave',
      })
    end,
  },
  {
    'willothy/flatten.nvim',
    version = '^0.5.1',
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
          option_toggle_prefix = [[<Leader>ot]],

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
  { -- TMUX movement integration
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
      'TmuxNavigatorProcessList',
    },
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    },
    init = function()
      -- from https://github.com/alexghergh/nvim-tmux-navigation/blob/4898c98702954439233fdaf764c39636681e2861/lua/nvim-tmux-navigation/tmux_util.lua#L10-L13
      local function tmux_command(command)
        local tmux_socket = vim.fn.split(vim.env.TMUX, ',')[1]
        return vim.fn.system('tmux -S ' .. tmux_socket .. ' ' .. command)
      end
      -- solution based on https://github.com/christoomey/vim-tmux-navigator/issues/295#issuecomment-1123455337
      local function set_is_vim()
        tmux_command('set-option -p @is_vim yes')
      end
      local function unset_is_vim()
        tmux_command('set-option -p -u @is_vim')
      end
      vim.api.nvim_create_augroup('tmux_navigator_is_vim', {})
      vim.api.nvim_create_autocmd({ 'VimEnter', 'VimResume' }, {
        group = 'tmux_navigator_is_vim',
        pattern = { '*' },
        desc = 'Set is_vim when entering neovim for tmux',
        callback = set_is_vim,
      })
      vim.api.nvim_create_autocmd({ 'VimLeave', 'VimSuspend' }, {
        group = 'tmux_navigator_is_vim',
        pattern = { '*' },
        desc = 'Unset is_vim when entering neovim for tmux',
        callback = unset_is_vim,
      })
    end,
  },
  {
    'chrisgrieser/nvim-early-retirement',
    event = 'VeryLazy',
    config = function()
      require('early-retirement').setup({
        ignoredFiletypes = require('config.filetype_excludes'),
        minimumBufferNum = 6,
        notificationOnAutoClose = true,
      })
    end,
  },
  -- {
  --   'wurli/contextindent.nvim',
  --   opts = { pattern = '*' },
  --   dependencies = { 'nvim-treesitter/nvim-treesitter' },
  -- },
  -- {
  --   'Faria22/ftmemo.nvim',
  --   config = function()
  --     require('ftmemo').setup()
  --   end,
  -- },
}
