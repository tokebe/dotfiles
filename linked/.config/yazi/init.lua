-- Show host in top path
Header:children_add(function()
  if ya.target_family() ~= 'unix' then
    return ''
  end
  return ui.Span(ya.user_name() .. '@' .. ya.host_name() .. ':'):fg('blue')
end, 500, Header.LEFT)

-- Show symlink in status bar
Status:children_add(function(self)
  local h = self._current.hovered
  if h and h.link_to then
    return ' -> ' .. tostring(h.link_to)
  else
    return ''
  end
end, 3300, Status.LEFT)

-- Show modify time in status bar
Status:children_add(function()
  local h = cx.active.current.hovered
  local elements = {}

  local mtime_formatted = nil
  if h and h.cha and h.cha.mtime then
    local timestamp_num = tonumber(h.cha.mtime)
    if timestamp_num and timestamp_num > 0 then
      mtime_formatted = os.date('%Y-%m-%d %H:%M', math.floor(timestamp_num))
    end
  end

  if mtime_formatted then
    table.insert(elements, ui.Span('󱦺  '):fg('darkgray'))
    table.insert(elements, ui.Span(mtime_formatted .. ' '):fg('darkgray'))
  end

  return ui.Line(elements)
end, 500, Status.RIGHT)

-- Git plugins
require('git'):setup({
  -- Order of status signs showing in the linemode
  order = 1500,
})
require("githead"):setup()
