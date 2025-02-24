-- Pull in the wezterm API
local wezterm = require('wezterm')

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Appearance
local colorscheme = 'rose-pine-moon'
local colorscheme_table = wezterm.color.get_builtin_schemes()[colorscheme]
config.color_scheme = colorscheme
config.window_background_opacity = 0.95
config.macos_window_background_blur = 100
config.font = wezterm.font('Tokebe Nerd Font')
config.font_size = require('fontsize')
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }
-- config.line_height = 1.1
config.window_decorations = 'RESIZE'
config.enable_scroll_bar = false
config.window_padding = {
  right = '10px',
  left = '10px',
  top = '10px',
  bottom = '10px',
}

-- Tabs
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false
config.tab_max_width = 64
config.tab_bar_style = {
  -- new_tab = wezterm.format({
  -- 	{ Foreground = { Color = colorscheme_table.selection_bg } },
  -- 	{ Background = { Color = colorscheme_table.ansi[1] } },
  -- 	{ Text = "█" },
  -- 	{ Foreground = { Color = colorscheme_table.foreground } },
  -- 	{ Background = { Color = colorscheme_table.selection_bg } },
  -- 	{ Text = " + " },
  -- 	{ Foreground = { Color = colorscheme_table.selection_bg } },
  -- 	{ Background = { Color = colorscheme_table.ansi[1] } },
  -- 	{ Text = "█" },
  -- }),
  -- new_tab_hover = wezterm.format({
  -- 	{ Foreground = { Color = colorscheme_table.brights[5] } },
  -- 	{ Background = { Color = colorscheme_table.ansi[1] } },
  -- 	{ Text = "█" },
  -- 	{ Foreground = { Color = colorscheme_table.foreground } },
  -- 	{ Background = { Color = colorscheme_table.brights[5] } },
  -- 	{ Text = " + " },
  -- 	{ Foreground = { Color = colorscheme_table.brights[5] } },
  -- 	{ Background = { Color = colorscheme_table.ansi[1] } },
  -- 	{ Text = "█" },
  -- }),
}

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

wezterm.on('format-tab-title', function(tab, tabs, _, _, _, max_width)
  local fg = colorscheme_table.selection_bg
  local bg = colorscheme_table.ansi[1]
  local text = colorscheme_table.foreground
  if tab.is_active then
    bg = colorscheme_table.brights[5]
    -- fg = colorscheme_table.brights[5]
    text = colorscheme_table.ansi[1]
  end
  local left_glyph = '│'
  local left_glyph_fg = fg
  if tab.tab_index == 0 and tab.is_active then
    left_glyph_fg = bg
  elseif tab.is_active then
    left_glyph_fg = text
  end
  local tab_right_of_active = tab.tab_index > 0 and tabs[tab.tab_index].is_active
  if tab.is_active or tab.tab_index < 1 or tab_right_of_active then
    left_glyph = ' '
    if tab.is_active then
      left_glyph = '█'
    end
    -- if tab.tab_index == 0 then
    -- 	left_glyph = " "
    -- end
  end
  local right_glyph = '█'
  if tab.tab_index - 1 == #tabs then
    right_glyph = ''
  end
  local title = tab_title(tab)
  if title:len() + 4 > max_width then
    local final_title = ''
    local string_to_slice
    local substrings = {}
    for str in string.gmatch(title, '([^' .. ' ' .. ']+)') do
      table.insert(substrings, str)
    end
    if substrings[1]:len() + 4 > max_width then
      string_to_slice = substrings[1]
    else
      final_title = substrings[1]
      for _, substring in substrings do
        string_to_slice = string_to_slice .. ' ' .. substring
      end
    end
    final_title = final_title
      .. '…'
      .. string_to_slice:sub(string_to_slice:len() - (max_width - (final_title:len() + 6)))
    title = final_title
  end
  return {
    { Foreground = { Color = left_glyph_fg } },
    { Background = { Color = tab.is_active and fg or bg } },
    { Text = left_glyph },
    { Foreground = { Color = bg } },
    { Background = { Color = bg } },
    { Text = '█' },
    { Foreground = { Color = text } },
    { Background = { Color = bg } },
    { Text = ' ' .. title .. ' ' },
    { Foreground = { Color = bg } },
    { Background = { Color = fg } },
    { Text = right_glyph },
  }
end)

-- and finally, return the configuration to wezterm
return config
