local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- Color scheme
config.color_scheme = "tokyonight_moon"

-- Background opacity
config.window_background_opacity = 0.95

-- Tab bar
config.hide_tab_bar_if_only_one_tab = true

-- Font
config.font = wezterm.font("Monaspace Argon")

return config
