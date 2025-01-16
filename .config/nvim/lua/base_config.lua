-- [[ Setting options ]]
-- See `:help set`

-- [[ Some shorthands ]]
local set = vim.opt
local cmd = vim.cmd

-- [[ Visual Config ]]
set.scrolloff = 10 -- keep cursor 1 away from edge when scrolling
set.sidescrolloff = 15 -- keep 30 columns around cursor
set.showmatch = true -- matching bracket pairs
set.cursorline = true -- highlight current line
set.number = true -- Make line numbers default
set.wrap = true -- Softwrap lines
set.breakindent = true -- Wrapped lines preserve indent
-- set.signcolumn = 'yes' -- Keep signcolumn on by default
set.completeopt = 'menuone,noselect' -- Set completeopt to have a better completion experience
set.splitbelow = true -- open horizontal splits below current window
set.splitright = true -- open vertical splits to the right of the current window
set.splitkeep = 'screen'
set.laststatus = 3 -- always show status line
set.colorcolumn = '88' -- default max line length hint
set.termguicolors = true -- terminal gui colors

-- [[ Search Config ]]
set.hlsearch = true -- highlight search
set.incsearch = true -- highlight next differently
set.ignorecase = true -- ignore pattern case
set.smartcase = true -- case-sensitive if pattern has uppercase
set.whichwrap:append({ h = true, l = true })
-- Set options for diff
-- filler: use filler for missing lines
-- context:3: show 3 lines of context around changes
-- closeoff: diffoff if a diff window is closed
-- followwrap: respect global wrap option
-- linematch:60: allow second-layer diff up to a max of 60 lines (30 for a 2-file diff)
set.diffopt = 'filler,context:3,closeoff,followwrap,linematch:60'

-- [[ Simple keybinds ]]
vim.keymap.set('n', 'q:', '<nop>')

-- [[ General Behaviors ]]
set.mouse = 'a' -- Enable mouse mode
set.mousemoveevent = true
set.expandtab = true -- Insert spaces instead of tab
set.softtabstop = 2
set.shiftwidth = 2 -- spaces per tab (when shifting), when using the >> or << commands, shift lines by 4 spaces
set.tabstop = 2 -- spaces per tab
set.smarttab = true -- <tab>/<BS> indent/dedent in leading whitespace
set.smartindent = true
set.autoindent = true -- maintain indent of current line
set.shiftround = true
set.shell = 'zsh' -- shell to use for `!`, `:!`, `system()` etc.
set.foldlevelstart = 99 -- UFO will handle folding
set.sessionoptions = 'blank,buffers,curdir,globals,tabpages'
vim.g.sessionoptions = 'blank,buffers,curdir,globals,tabpages'
-- Auto-refresh on file changes, requires autocommand to work properly
-- ( see keymap )
set.autoread = true
-- Disables swap file since autosave is used
-- Disable this if you have crashes that lose progress
set.swapfile = true

-- Sync clipboard between OS and Neovim.
--  See `:help 'clipboard'`
set.clipboard = 'unnamedplus'

set.undofile = true -- Save undo history

-- Set update time
set.updatetime = 100
set.timeout = true
set.timeoutlen = 500

-- set.lazyredraw = true -- faster scrolling
cmd([[au BufEnter * set fo-=c fo-=r fo-=o]]) -- no autocomment on newline
cmd('filetype plugin indent on') -- filetype detection

-- Neovide config
vim.o.guifont = 'Tokebe Nerd Font:h14:#e-antialias'

vim.g.neovide_refrest_rate = 100
vim.g.neovide_no_idle = true
-- vim.g.neovide_refrest_rate_idle = 5
vim.g.neovide_cursor_animation_length = 0 -- Handled with plugin
vim.g.neovide_floating_shadow = false -- Interacts weirdly
vim.g.neovide_cursor_antialiasing = true
vim.g.neovide_cursor_animate_in_insert_mode = true
vim.g.neovide_scroll_animation_length = 0
vim.g.neovide_input_macos_alt_is_meta = true
vim.g.neovide_padding_top = 10
vim.g.neovide_padding_bottom = 10
vim.g.neovide_padding_right = 10
vim.g.neovide_padding_left = 10
vim.g.neovide_floating_blur_amount_x = 0
vim.g.neovide_floating_blur_amount_y = 0
