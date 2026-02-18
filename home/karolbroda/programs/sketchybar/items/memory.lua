local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local memory = sbar.add("item", "memory", {
  position = "right",
  update_freq = settings.update.memory,
  icon = {
    string = icons.memory.text,
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Medium"],
      size = settings.font_size.icon,
    },
    color = colors.yellow,
    padding_left = 4,
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

memory:subscribe("routine", function(env)
  sbar.exec("memory_pressure | grep 'System-wide memory free percentage:' | awk '{print 100-$5}' | sed 's/%//'", function(output)
    local mem_usage = tonumber(output)
    if mem_usage ~= nil then
      mem_usage = math.floor(mem_usage + 0.5)
      
      local icon_color = colors.yellow
      if mem_usage > 85 then icon_color = colors.red
      elseif mem_usage > 70 then icon_color = colors.peach end
      
      memory:set({
        label = { string = string.format("%d%%", mem_usage) },
        icon = { color = icon_color },
      })
    end
  end)
end)

memory:subscribe("mouse.entered", function(env)
  sbar.animate(settings.animation.easing, settings.animation.duration, function()
    memory:set({ label = { color = colors.yellow } })
  end)
end)

memory:subscribe("mouse.exited", function(env)
  sbar.animate(settings.animation.easing, settings.animation.duration, function()
    memory:set({ label = { color = colors.text } })
  end)
end)

return memory
