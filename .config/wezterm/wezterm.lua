local wezterm = require("wezterm")

local act = wezterm.action
local config = wezterm.config_builder()

-- Background opacity
local bg_opacity = 0.80
config.window_background_opacity = bg_opacity

-- Font
config.font = wezterm.font("Monaspace Argon")
config.font_size = 14.0

-- Color scheme
local color_scheme = "tokyonight_moon"
local colors = wezterm.get_builtin_color_schemes()[color_scheme]

---Adjusts the alpha channel of a color
---@param color string
---@param new_opacity number
local function adjust_opacity(color, new_opacity)
	if new_opacity < 0 or new_opacity > 1 then
		print("new opacity must be between 0 and 1")
		return
	end

	local h, s, l, _ = wezterm.color.parse(color):hsla()
	return wezterm.color.from_hsla(h, s, l, new_opacity)
end

-- The opacity adjusted background color of the theme
local bg = adjust_opacity(colors.background, bg_opacity)

config.color_scheme = color_scheme

-- Tab bar
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

config.colors = {
	tab_bar = {
		background = bg,
	},
}

-- Window padding
config.window_padding = {
	top = 20, -- This is currently working for keeping the bottom padding minimal due to window resizing
	bottom = 0,
}

-- Remove top window bar
config.window_decorations = "RESIZE"

-- Resize behaviour
config.adjust_window_size_when_changing_font_size = false

-- Scrollback lines
config.scrollback_lines = 1000

-- Keymaps
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
	-- New tab
	{ mods = "LEADER", key = "c", action = act.SpawnTab("CurrentPaneDomain") },
	-- Close tab/pane
	{ mods = "LEADER", key = "x", action = act.CloseCurrentPane({ confirm = true }) },
	-- Previous tab
	{ mods = "LEADER", key = "b", action = act.ActivateTabRelative(-1) },
	-- Next tab
	{ mods = "LEADER", key = "n", action = act.ActivateTabRelative(1) },
	-- Split horizontal
	{ mods = "LEADER", key = "|", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	-- Split vertical
	{ mods = "LEADER", key = "-", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	-- Pane navigation
	{ mods = "CTRL", key = "h", action = act.ActivatePaneDirection("Left") },
	{ mods = "CTRL", key = "j", action = act.ActivatePaneDirection("Down") },
	{ mods = "CTRL", key = "k", action = act.ActivatePaneDirection("Up") },
	{ mods = "CTRL", key = "l", action = act.ActivatePaneDirection("Right") },
	-- Zoom pane
	{ mods = "LEADER", key = "z", action = act.TogglePaneZoomState },
	-- Key table activations
	-- Resize mode
	{ mods = "LEADER", key = "r", action = act.ActivateKeyTable({ name = "resize", one_shot = false }) },
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
	{ mods = "LEADER", key = "o", action = wezterm.action.EmitEvent("toggle-opacity") },
	-- Scroll by page
	{ mods = "CTRL", key = "[", action = act.ScrollByPage(-1) },
	{ mods = "CTRL", key = "]", action = act.ScrollByPage(1) },
	-- Show Launcher
	{ mods = "LEADER", key = "l", action = wezterm.action.ShowLauncher },
	-- Workspaces
	{
		mods = "LEADER",
		key = "w",
		action = wezterm.action.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
}

-- Move to numbered tab
for i = 1, 8 do
	table.insert(config.keys, {
		mods = "LEADER",
		key = tostring(i),
		action = act.ActivateTab(i - 1),
	})
end

config.key_tables = {
	resize = {
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

-- Update functions

-- Show which key table is active in the status area
wezterm.on("update-status", function(window, pane)
	local mode = string.upper(string.sub(window:active_key_table() or "Normal", 1, 1))
	local date = wezterm.strftime("%-d ")
	local time = wezterm.strftime("%H:%M ")

	window:set_right_status(wezterm.format({
		-- { Background = { AnsiColor = "Olive" } },
		-- { Foreground = { AnsiColor = "Black" } },
		-- { Text = mode or "N" .. " " },
		{ Background = { AnsiColor = "Fuchsia" } },
		{ Foreground = { AnsiColor = "Black" } },
		{ Text = " " .. wezterm.nerdfonts.fa_calendar_o .. " " .. date .. wezterm.nerdfonts.fa_clock_o .. " " .. time },
	}))

	window:set_left_status(wezterm.format({
		{ Background = { AnsiColor = "Fuchsia" } },
		{ Foreground = { AnsiColor = "Black" } },
		{ Text = " " .. wezterm.nerdfonts.dev_terminal .. " " .. window:active_workspace() .. " " },
	}) .. " ")
end)

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab_title(tab)
	local tab_number = tostring(tab.tab_index + 1)

	if tab.is_active then
		return {
			{ Background = { Color = bg } },
			{ Foreground = { AnsiColor = "Lime" } },
			{ Text = wezterm.nerdfonts.ple_left_half_circle_thick },
			{ Background = { AnsiColor = "Lime" } },
			{ Foreground = { AnsiColor = "Black" } },
			{ Text = tab_number .. ": " .. title },
			{ Background = { Color = bg } },
			{ Foreground = { AnsiColor = "Lime" } },
			{ Text = wezterm.nerdfonts.ple_right_half_circle_thick },
			{ Background = { Color = bg } },
			{ Text = " " },
		}
	else
		return {
			{ Background = { Color = bg } },
			{ Foreground = { AnsiColor = "Grey" } },
			{ Text = wezterm.nerdfonts.ple_left_half_circle_thick },
			{ Background = { AnsiColor = "Grey" } },
			{ Foreground = { AnsiColor = "Olive" } },
			{ Text = tab_number .. ": " .. title },
			{ Background = { Color = bg } },
			{ Foreground = { AnsiColor = "Grey" } },
			{ Text = wezterm.nerdfonts.ple_right_half_circle_thick },
			{ Background = { Color = bg } },
			{ Text = " " },
		}
	end
end)

-- Toggles opacity between 1 and the configured value
wezterm.on("toggle-opacity", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 1
	else
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)

-- Plugins --
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
workspace_switcher.apply_to_config(config)
-- table.insert(config.keys, {
-- 	{
-- 		key = "s",
-- 		mods = "LEADER",
-- 		action = workspace_switcher.switch_workspace(),
-- 	},
-- 	{
-- 		key = "S",
-- 		mods = "LEADER",
-- 		action = workspace_switcher.switch_to_prev_workspace(),
-- 	},
-- })

return config
