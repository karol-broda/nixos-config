local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local calendar = sbar.add("item", "calendar", {
  position = "right",
  update_freq = settings.update.calendar,
  icon = {
    string = icons.clock.text,
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Medium"],
      size = settings.font_size.icon,
    },
    color = colors.mauve,
    padding_left = 4,
    padding_right = 3,
  },
  label = {
    string = "00:00",
    font = {
      family = settings.font.mono,
      style = settings.font.style_map["Medium"],
      size = settings.font_size.label,
    },
    color = colors.text,
    padding_left = 0,
    padding_right = 8,
  },
  background = { drawing = false },
  padding_left = 0,
  padding_right = 0,
})

local function update_calendar()
  sbar.exec("date '+%H:%M'", function(output)
    local time = output:match("^%s*(.-)%s*$")
    calendar:set({ label = { string = time } })
  end)
end

calendar:subscribe("routine", function(env)
  update_calendar()
end)

calendar:subscribe("mouse.clicked", function(env)
  sbar.exec("open -a Calendar")
end)

calendar:subscribe("mouse.entered", function(env)
  sbar.animate(settings.animation.easing, settings.animation.duration, function()
    calendar:set({ label = { color = colors.mauve } })
  end)
end)

calendar:subscribe("mouse.exited", function(env)
  sbar.animate(settings.animation.easing, settings.animation.duration, function()
    calendar:set({ label = { color = colors.text } })
  end)
end)

update_calendar()

return calendar
