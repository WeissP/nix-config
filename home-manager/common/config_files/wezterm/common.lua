local wezterm = require("wezterm")
local act = wezterm.action
local copy_mode = nil

local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({
	"FiraCode Nerd Font Mono",
	"WenQuanYi Micro Hei Mono",
	"Noto Sans",
	"Noto Sans symbols",
	"Noto Sans symbols 2",
	"Noto Sans Math",
	"Noto Color Emoji",
})
config.front_end = "WebGpu"
config.font_size = 13
config.color_scheme = "WeissDark"
config.scrollback_lines = 3500
config.enable_scroll_bar = true
config.leader = { key = "End", timeout_milliseconds = 1000 }
config.quick_select_patterns = {
	"nix log ([^']+)",
}
config.keys = {
	{
		key = "LeftArrow",
		mods = "CTRL",
		action = act.MoveTabRelative(-1),
	},
	{
		key = "RightArrow",
		mods = "CTRL",
		action = act.MoveTabRelative(1),
	},
	{
		key = "v",
		mods = "CTRL",
		action = { PasteFrom = "Clipboard" },
	},
	{
		key = "s",
		mods = "LEADER",
		action = act.ActivateCopyMode,
	},
	{
		key = "c",
		mods = "LEADER",
		action = act.QuickSelect,
	},
	{
		key = "a",
		mods = "LEADER",
		action = act.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	{
		key = "w",
		mods = "LEADER",
		action = act.CloseCurrentPane({
			confirm = false,
		}),
	},
	{
		key = "t",
		mods = "CTRL",
		action = { SpawnTab = "CurrentPaneDomain" },
	},
	{
		key = "w",
		mods = "CTRL",
		action = { CloseCurrentTab = { confirm = true } },
	},
	{
		key = "K",
		mods = "CTRL",
		action = act.ClearScrollback("ScrollbackOnly"),
	},
	{
		key = "f",
		mods = "CTRL",
		action = { Search = { CaseSensitiveString = "" } },
	},
}
config.key_tables = {
	copy_mode = {

		{
			key = "o",
			mods = "NONE",
			action = act.CopyMode("MoveForwardWord"),
		},
		{
			key = "h",
			mods = "NONE",
			action = act.CopyMode("MoveToEndOfLineContent"),
		},
		{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
		{
			key = "Space",
			mods = "NONE",
			action = act.CopyMode({ SetSelectionMode = "Cell" }),
		},
		{ key = ",", mods = "NONE", action = act.CopyMode("JumpReverse") },
		{ key = "h", mods = "LEADER", action = act.CopyMode("MoveToViewportTop") },
		{ key = "i", mods = "NONE", action = act.CopyMode("MoveLeft") },
		{ key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
		{ key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
		{
			key = ":",
			mods = "SHIFT",
			action = act.CopyMode("MoveToSelectionOtherEndHoriz"),
		},
		{
			key = "e",
			mods = "NONE",
			action = act.CopyMode("PageUp"),
		},
		{
			key = "d",
			mods = "NONE",
			action = act.CopyMode("PageDown"),
		},
		{
			key = "Enter",
			mods = "NONE",
			action = act.Multiple({
				{ CopyTo = "ClipboardAndPrimarySelection" },
				{ CopyMode = "Close" },
			}),
		},
	},
}

return config
