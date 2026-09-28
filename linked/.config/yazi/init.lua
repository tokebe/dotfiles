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
