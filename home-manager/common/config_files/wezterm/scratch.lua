local wezterm = require 'wezterm'
local common = require "common"

wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
  local zoomed = ''
  if tab.active_pane.is_zoomed then
    zoomed = '[Z] '
  end

  local index = ''
  if #tabs > 1 then
    index = string.format('[%d/%d] ', tab.tab_index + 1, #tabs)
  end

  return "[Scratchpad]" .. zoomed .. index .. tab.active_pane.title
end)

return common
