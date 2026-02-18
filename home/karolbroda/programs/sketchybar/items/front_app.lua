local colors = require("colors")
local settings = require("settings")

local separator = sbar.add("item", "front_app.separator", {
  position = "left",
  icon = {
    string = "│",
    font = {
      family = settings.font.text,
      size = 12.0,
    },
    color = colors.surface2,
    padding_left = 4,
    padding_right = 4,
  },
  label = { drawing = false },
  background = { drawing = false },
  padding_left = 0,
  padding_right = 0,
})

local front_app = sbar.add("item", "front_app", {
  position = "left",
  display = "active",
  icon = { drawing = false },
  label = {
    string = "Desktop",
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Medium"],
      size = settings.font_size.label,
    },
    color = colors.subtext1,
    padding_left = 4,
    padding_right = 8,
  },
  background = { drawing = false },
  padding_left = 0,
  padding_right = 0,
})

front_app:subscribe("front_app_switched", function(env)
  local app_name = env.INFO or "Desktop"
  
  if #app_name > 18 then
    app_name = app_name:sub(1, 16) .. "…"
  end
  
  front_app:set({ label = { string = app_name } })
end)

front_app:subscribe("mouse.entered", function(env)
  sbar.animate(settings.animation.easing, settings.animation.duration, function()
    front_app:set({ label = { color = colors.text } })
  end)
end)

front_app:subscribe("mouse.exited", function(env)
  sbar.animate(settings.animation.easing, settings.animation.duration, function()
    front_app:set({ label = { color = colors.subtext1 } })
  end)
end)

return front_app
