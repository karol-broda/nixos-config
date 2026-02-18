local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local cpu = sbar.add("item", "cpu", {
  position = "right",
  update_freq = settings.update.cpu,
  icon = {
    string = icons.cpu.text,
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Medium"],
      size = settings.font_size.icon,
    },
    color = colors.green,
    padding_left = 8,
    padding_right = 3,
  },
  label = {
    string = "-%",
    font = {
      family = settings.font.mono,
      style = settings.font.style_map["Medium"],
      size = settings.font_size.label,
    },
    color = colors.text,
    padding_left = 0,
    padding_right = 4,
  },
  background = { drawing = false },
  padding_left = 0,
  padding_right = 0,
})

cpu:subscribe("routine", function(env)
  sbar.exec("top -l 2 -n 0 -F | grep 'CPU usage' | tail -n 1 | awk '{print $3}' | sed 's/%//'", function(output)
    local cpu_usage = tonumber(output)
    if cpu_usage ~= nil then
      cpu_usage = math.floor(cpu_usage + 0.5)
      
      local icon_color = colors.green
      if cpu_usage > 80 then icon_color = colors.red
      elseif cpu_usage > 60 then icon_color = colors.peach
      elseif cpu_usage > 40 then icon_color = colors.yellow end
      
      cpu:set({
        label = { string = string.format("%d%%", cpu_usage) },
        icon = { color = icon_color },
      })
    end
  end)
end)

cpu:subscribe("mouse.entered", function(env)
  sbar.animate(settings.animation.easing, settings.animation.duration, function()
    cpu:set({ label = { color = colors.green } })
  end)
end)

cpu:subscribe("mouse.exited", function(env)
  sbar.animate(settings.animation.easing, settings.animation.duration, function()
    cpu:set({ label = { color = colors.text } })
  end)
end)

return cpu
