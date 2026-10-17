local terminal = "wezterm"
local fileManager = "dolphin"
local menu = "rofi -show drun"
local mainMod = "SUPER"
local shiftMainMod = "SUPER + SHIFT"

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1,
})

hl.env("AQ_DRM_DEVICES", "/dev/dri/dgpu:/dev/dri/igpu")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "catppuccin-frappe-lavender-cursors")

hl.config({
	ecosystem = {
		enforce_permissions = true,
	},
})

hl.permission(".*quickshell.*", "screencopy", "allow")
hl.permission(".*grim.*", "screencopy", "allow")

hl.on("hyprland.start", function()
	hl.exec_cmd(
		"systemctl --user import-environment WAYLAND_DISPLAY XDG_RUNTIME_DIR HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP"
	)
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)

hl.config({
	general = {
		gaps_in = 6,
		gaps_out = 18,
		border_size = 3,
		col = {
			active_border = { colors = { colors.lavender, colors.mauve }, angle = 45 },
			inactive_border = "rgba(8c8fa1aa)",
		},
		layout = "dwindle",
		resize_on_border = false,
		allow_tearing = false,
	},

	decoration = {
		rounding = 12,
		rounding_power = 2,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		shadow = {
			enabled = true,
			range = 20,
			render_power = 3,
			color = "rgba(00000055)",
		},
		blur = {
			enabled = true,
			size = 8,
			passes = 2,
			ignore_opacity = false,
			vibrancy = 0.12,
		},
	},

	animations = {
		enabled = true,
	},

	misc = {
		disable_hyprland_logo = true,
		focus_on_activate = true,
	},

	input = {
		kb_layout = "us,de,pl",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = true,
			disable_while_typing = false,
			tap_to_click = true,
			clickfinger_behavior = true,
		},
	},

	cursor = {
		no_hardware_cursors = true,
		hide_on_key_press = true,
	},
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 7, bezier = "easeInOutCubic" })
hl.animation({ leaf = "border", enabled = true, speed = 6, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 6, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, bezier = "easeOutQuint", style = "popin 85%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "almostLinear", style = "popin 85%" })
hl.animation({ leaf = "fade", enabled = true, speed = 6, bezier = "quick" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 5, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 4, bezier = "almostLinear" })
hl.animation({ leaf = "layers", enabled = true, speed = 6, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 5, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 4, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "almostLinear", style = "fade" })

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen_state({ internal = 1, client = 1, action = "toggle" }))
hl.bind(shiftMainMod .. " + F", hl.dsp.window.fullscreen_state({ internal = 2, client = 2, action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + D", hl.dsp.global("quickshell:dashboard"))
hl.bind(mainMod .. " + SPACE", hl.dsp.global("quickshell:launcher"))
hl.bind(shiftMainMod .. " + SPACE", hl.dsp.exec_cmd("1password --quick-access"))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.global("quickshell:lock"))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("hyprctl switchxkblayout all next"))

hl.bind("Print", hl.dsp.global("quickshell:screenshot"))
hl.bind("SHIFT + Print", hl.dsp.global("quickshell:screenshotFreeze"))
hl.bind("SUPER + Print", hl.dsp.global("quickshell:screenshot"))
hl.bind("SUPER + SHIFT + Print", hl.dsp.global("quickshell:screenshotFreeze"))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(shiftMainMod .. " + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + ALT + period", hl.dsp.focus({ monitor = "+1" }))
hl.bind(mainMod .. " + ALT + comma", hl.dsp.focus({ monitor = "-1" }))
hl.bind(shiftMainMod .. " + period", hl.dsp.workspace.move({ monitor = "+1" }))
hl.bind(shiftMainMod .. " + comma", hl.dsp.workspace.move({ monitor = "-1" }))

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(shiftMainMod .. " + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(shiftMainMod .. " + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind(shiftMainMod .. " + J", hl.dsp.window.swap({ direction = "down" }))
hl.bind(shiftMainMod .. " + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind(shiftMainMod .. " + L", hl.dsp.window.swap({ direction = "right" }))

hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 30, relative = true }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -30, relative = true }))

hl.bind("ALT + f4", hl.dsp.exec_cmd("xdg-open https://www.youtube.com/watch?v=dQw4w9WgXcQ"))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind(
	mainMod .. " + CTRL + B",
	function()
		hl.timer(function()
			hl.dispatch(hl.dsp.dpms({ action = "toggle", monitor = "eDP-2" }))
		end, { timeout = 500, type = "oneshot" })
	end,
	{ locked = true }
)

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("hyprctl keyword monitor 'eDP-2, disable'"), { locked = true })
hl.bind(
	"switch:off:Lid Switch",
	hl.dsp.exec_cmd("hyprctl keyword monitor 'eDP-2, preferred, auto, 1'"),
	{ locked = true }
)

hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
	},
	no_focus = true,
})

hl.window_rule({
	name = "float-pavucontrol",
	match = { class = "^(pavucontrol)$" },
	float = true,
})

hl.window_rule({
	name = "picture-in-picture",
	match = { title = "^(Picture-in-Picture)$" },
	float = true,
	pin = true,
	no_focus = true,
	suppress_event = "activatefocus",
})
