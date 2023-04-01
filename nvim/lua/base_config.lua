-- [[ Setting options ]]
-- See `:help set`

-- [[ Some shorthands ]]
local exec = vim.api.nvim_exec
local set = vim.opt
local cmd = vim.cmd

-- [[ Visual Config ]]
set.scrolloff = 1 -- keep cursor 1 away from edge when scrolling
set.sidescrolloff = 2 -- keep 30 columns around cursor
set.showmatch = true -- matching bracket pairs
set.cursorline = true -- highlight current line
set.number = true -- Make line numbers default
set.breakindent = true -- Wrapped lines preserve indent
set.signcolumn = 'yes' -- Keep signcolumn on by default

-- [[ Search Config ]]
set.hlsearch = true -- highlight search
set.incsearch = true -- highlight next differently
set.ignorecase = true -- ignore pattern case
set.smartcase = true -- case-sensitive if pattern has uppercase



-- Enable mouse mode
set.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  See `:help 'clipboard'`
set.clipboard = 'unnamedplus'



-- Save undo history
set.undofile = true



-- Set update time
set.updatetime = 100
set.timeout = true
set.timeoutlen = 500

-- Set completeopt to have a better completion experience
set.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
set.termguicolors = true
