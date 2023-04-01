--[[ 
This config is loosely based on https://github.com/nvim-lua/kickstart.nvim, thanks to them!

The main changes are that this structure seeks to even further break configuration into multiple
files, for the sake of separation of concerns. Configs for things will only be grouped if it 
makes sense to do so.

Wish me luck.
--]]

-- [[ Set up basic keybinds ]]
require('base_keybinds')

-- [[ Set up basic options ]]
require('base_config')
