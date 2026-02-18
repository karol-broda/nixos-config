local colors = require("colors")
local settings = require("settings")

sbar.bar({
  position = "top",
  height = settings.bar.height,
  margin = 0,
  y_offset = 0,
  corner_radius = 0,
  
  color = colors.bar,
  border_color = colors.transparent,
  border_width = 0,
  
  blur_radius = 0,
  
  padding_left = 8,
  padding_right = 8,
  
  topmost = settings.display.topmost,
  sticky = settings.display.sticky and "on" or "off",
  font_smoothing = "on",
  display = "all",
  hidden = "off",
})
