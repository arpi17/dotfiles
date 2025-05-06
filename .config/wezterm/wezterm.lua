local wezterm = require("wezterm")

local act = wezterm.action
local config = wezterm.config_builder()

-- Color scheme
config.color_scheme = "tokyonight_moon"

-- Background opacity
config.window_background_opacity = 0.95

-- Font
config.font = wezterm.font("Monaspace Argon")

-- Tab bar
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

-- Remove top window bar
config.window_decorations = "RESIZE"

-- Scrollback lines
config.scrollback_lines = 1000

-- Keymaps
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
	-- New tab
	{
		mods = "LEADER",
		key = "c",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	-- Close tab/pane
	{
		mods = "LEADER",
		key = "x",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	-- Previous tab
	{
		mods = "LEADER",
		key = "b",
		action = act.ActivateTabRelative(-1),
	},
	-- Next tab
	{
		mods = "LEADER",
		key = "n",
		action = act.ActivateTabRelative(1),
	},
	-- Split horizontal
	{
		mods = "LEADER",
		key = "|",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- Split vertical
	{
		mods = "LEADER",
		key = "-",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- Pane navigation
	{
		mods = "CTRL",
		key = "h",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		mods = "CTRL",
		key = "j",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		mods = "CTRL",
		key = "k",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		mods = "CTRL",
		key = "l",
		action = act.ActivatePaneDirection("Right"),
	},
	-- Zoom pane
	{
		mods = "LEADER",
		key = "z",
		action = act.TogglePaneZoomState,
	},
	-- Key table activations
	-- Resize mode
	{
		mods = "LEADER",
		key = "r",
		action = act.ActivateKeyTable({
			name = "resize_pane",
			one_shot = false,
		}),
	},
	-- Prompt for renaming tab
	{
		mods = "LEADER",
		key = ":",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

config.key_tables = {
	resize_pane = {
		{ key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		-- Escape cancels
		{ key = "Escape", action = "PopKeyTable" },
	},
}

-- Show which key table is active in the status area
wezterm.on("update-right-status", function(window, pane)
	local name = window:active_key_table()
	window:set_right_status(name or "")
end)

return config
