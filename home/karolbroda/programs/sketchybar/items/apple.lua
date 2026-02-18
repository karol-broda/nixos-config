local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local apple = sbar.add("item", "apple.logo", {
  position = "left",
  icon = {
    string = icons.apple.text,
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Bold"],
      size = 14.0,
    },
    color = colors.lavender,
    padding_left = 8,
    padding_right = 4,
  },
  label = { drawing = false },
  background = { drawing = false },
  padding_left = 0,
  padding_right = 2,
})

apple:subscribe("mouse.entered", function(env)
  sbar.animate(settings.animation.easing, settings.animation.duration, function()
    apple:set({ icon = { color = colors.text } })
  end)
end)

apple:subscribe("mouse.exited", function(env)
  sbar.animate(settings.animation.easing, settings.animation.duration, function()
    apple:set({ icon = { color = colors.lavender } })
  end)
end)

return apple
