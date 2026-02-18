local colors = require("colors")
local settings = require("settings")

require("items.apple")
require("items.spaces")
require("items.front_app")

-- order: rightmost first
require("items.calendar")
require("items.battery")
require("items.volume")
require("items.memory")
require("items.cpu")

local left_items = { "apple.logo" }
for _, ws in ipairs(settings.aerospace.workspaces) do
  table.insert(left_items, "space." .. ws)
end
table.insert(left_items, "front_app.separator")
table.insert(left_items, "front_app")

sbar.add("bracket", "island.left", left_items, {
  background = {
    color = colors.island,
    corner_radius = settings.island.corner_radius,
    height = settings.island.height,
    border_color = colors.island_border,
    border_width = 1,
    drawing = true,
  },
})

sbar.add("bracket", "island.right", { "cpu", "memory", "volume", "battery", "calendar" }, {
  background = {
    color = colors.island,
    corner_radius = settings.island.corner_radius,
    height = settings.island.height,
    border_color = colors.island_border,
    border_width = 1,
    drawing = true,
  },
})

sbar.exec("sketchybar --update")
