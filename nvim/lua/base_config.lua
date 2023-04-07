-- [[ Setting options ]]
-- See `:help set`

-- [[ Some shorthands ]]
local exec = vim.api.nvim_exec
local set = vim.opt
local cmd = vim.cmd

-- [[ Visual Config ]]
set.scrolloff = 20                   -- keep cursor 1 away from edge when scrolling
set.sidescrolloff = 15               -- keep 30 columns around cursor
set.showmatch = true                 -- matching bracket pairs
set.cursorline = true                -- highlight current line
set.number = true                    -- Make line numbers default
set.breakindent = true               -- Wrapped lines preserve indent
set.signcolumn = 'yes'                -- Keep signcolumn on by default
set.completeopt = 'menuone,noselect' -- Set completeopt to have a better completion experience
set.splitbelow = true                -- open horizontal splits below current window
set.splitright = true                -- open vertical splits to the right of the current window
set.laststatus = 2                   -- always show status line
set.colorcolumn = '88'               -- default max line length hint
set.fillchars = 'eob: '
set.termguicolors = true             -- terminal gui colors

-- [[ Search Config ]]
set.hlsearch = true   -- highlight search
set.incsearch = true  -- highlight next differently
set.ignorecase = true -- ignore pattern case
set.smartcase = true  -- case-sensitive if pattern has uppercase

-- [[ General Behaviors ]]
set.mouse = 'a'       -- Enable mouse mode
set.expandtab = true  -- Insert spaces instead of tab
set.softtabstop = 2
set.shiftwidth = 2    -- spaces per tab (when shifting), when using the >> or << commands, shift lines by 4 spaces
set.tabstop = 2       -- spaces per tab
set.smarttab = true   -- <tab>/<BS> indent/dedent in leading whitespace
set.autoindent = true -- maintain indent of current line
set.shiftround = true
set.shell = "zsh"     -- shell to use for `!`, `:!`, `system()` etc.

-- Sync clipboard between OS and Neovim.
--  See `:help 'clipboard'`
set.clipboard = 'unnamedplus'

set.undofile = true -- Save undo history

-- Set update time
set.updatetime = 100
set.timeout = true
set.timeoutlen = 500

set.lazyredraw = true                        -- faster scrolling
cmd([[au BufEnter * set fo-=c fo-=r fo-=o]]) -- no autocomment on newline
cmd('filetype plugin indent on')             -- filetype detection
