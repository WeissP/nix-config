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

return config
