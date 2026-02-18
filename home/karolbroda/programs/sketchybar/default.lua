local colors = require("colors")
local settings = require("settings")

sbar.default({
  updates = "when_shown",
  
  icon = {
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Medium"],
      size = settings.font_size.icon,
    },
    color = colors.subtext1,
    padding_left = settings.icon_padding,
    padding_right = 2,
    background = {
      image = {
        corner_radius = settings.item.corner_radius,
        drawing = false,
      },
    },
  },
  
  label = {
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Medium"],
      size = settings.font_size.label,
    },
    color = colors.text,
    padding_left = 2,
    padding_right = settings.label_padding,
  },
  
  background = {
    height = settings.item.height,
    corner_radius = settings.item.corner_radius,
    border_width = 0,
    border_color = colors.transparent,
    color = colors.transparent,
    drawing = false,
  },
  
  popup = {
    align = "center",
    horizontal = false,
    background = {
      border_width = settings.popup.border_width,
      corner_radius = settings.popup.corner_radius,
      border_color = colors.popup_border,
      color = colors.popup_bg,
      shadow = {
        drawing = true,
        color = colors.shadow,
        angle = 90,
        distance = 4,
      },
    },
    blur_radius = settings.popup.blur_radius,
  },
  
  padding_left = settings.paddings,
  padding_right = settings.paddings,
  scroll_texts = true,
})
