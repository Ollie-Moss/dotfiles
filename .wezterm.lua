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
config.color_scheme = "Catppuccin Macchiato"
config.font_size = 12

config.window_background_opacity = 0.9

-- tab bar
config.enable_tab_bar = false

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.max_fps = 240

config.warn_about_missing_glyphs = false
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.enable_wayland = false

return config
