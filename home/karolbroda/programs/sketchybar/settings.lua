local settings = {}

settings.paddings = 3
settings.group_paddings = 5
settings.icon_padding = 6
settings.label_padding = 6

settings.icon_style = "phosphor"

settings.font = {
  text = "SF Pro",
  numbers = "SF Mono",
  mono = "SF Mono",
  style_map = {
    ["Regular"] = "Regular",
    ["Medium"] = "Medium",
    ["Semibold"] = "Semibold",
    ["Bold"] = "Bold",
    ["Heavy"] = "Heavy",
    ["Black"] = "Black",
  },
}

settings.font_size = {
  icon = 13.0,
  label = 12.0,
  small = 10.0,
  large = 15.0,
  workspace = 11.0,
}

-- bar configuration (transparent base, islands float on top)
settings.bar = {
  height = 36,
  corner_radius = 0,
  blur_radius = 0,
  margin = 0,
  y_offset = 0,
  border_width = 0,
}

-- island styling (the floating pill groups)
settings.island = {
  height = 26,
  corner_radius = 8,
  y_offset = 5,
  blur_radius = 20,
}

settings.item = {
  height = 22,
  corner_radius = 6,
  border_width = 0,
}

settings.bracket = {
  height = 24,
  corner_radius = 6,
  border_width = 0,
}

settings.popup = {
  corner_radius = 10,
  border_width = 1,
  blur_radius = 30,
}

settings.animation = {
  duration = 12,
  easing = "tanh",
}

settings.update = {
  cpu = 3,
  memory = 4,
  battery = 30,
  volume = 0,
  calendar = 30,
  network = 3,
}

-- aerospace workspaces (must match your aerospace config)
settings.aerospace = {
  workspaces = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" },
}

settings.display = {
  topmost = "window",
  sticky = true,
  shadow = false,
}

settings.features = {
  show_front_app = true,
  show_cpu = true,
  show_memory = true,
  show_network = false,
  show_volume = true,
  show_battery = true,
  show_calendar = true,
  show_media = false,
}

return settings
