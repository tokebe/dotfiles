--[[
This config is loosely based on https://github.com/nvim-lua/kickstart.nvim
Thanks to them!

The main changes are that this structure seeks to even further break
configuration into multiple files, for the sake of separation of concerns.
Configs for things will only be grouped if it makes sense to do so.

Wish me luck.
--]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required
-- (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- disable netrw for nvim-tree and other compatibility
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- [[ Set up basic options ]]
require("base_config")

-- [[ Set up plugins ]]
require("plugins")