-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- For example, changing the color scheme:
config.color_scheme = "Afterglow"
-- config.font_size = 12

config.window_background_opacity = 0.8

-- tab bar
config.enable_tab_bar = false

config.window_padding = {
	left = 2,
	right = 2,
	top = 2,
	bottom = 2,
}

config.max_fps = 240
config.enable_wayland = false
config.adjust_window_size_when_changing_font_size = false

config.warn_about_missing_glyphs = false
config.keys = {
	-- CTRL-SHIFT-l activates the debug overlay
	{ key = "L", mods = "CTRL", action = wezterm.action.ShowDebugOverlay },
}

config.skip_close_confirmation_for_processes_named = {
	"sh",
	"zsh",
	"fish",
	"nu",
	"cmd.exe",
	"pwsh.exe",
	"powershell.exe",
}

return config
