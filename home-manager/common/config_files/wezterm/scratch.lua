local wezterm = require("wezterm")
local config = require("nixed")

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local pane = tab.active_pane
	local path = pane.current_working_dir.file_path
	local lastFragment = path:match(".+/(.-)/?$")
	if pane.title == "nu" then
		return lastFragment
	else
		return pane.title
	end
end)

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
	local zoomed = ""
	if tab.active_pane.is_zoomed then
		zoomed = "[Z] "
	end

	local index = ""
	if #tabs > 1 then
		index = string.format("[%d/%d] ", tab.tab_index + 1, #tabs)
	end

	return "[Scratchpad]" .. zoomed .. index .. tab.active_pane.title
end)

return config
