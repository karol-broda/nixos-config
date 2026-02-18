local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local function get_battery_icon(percentage, charging)
  if charging then return icons.battery.charging.text end
  if percentage >= 90 then return icons.battery[100].text
  elseif percentage >= 70 then return icons.battery[80].text
  elseif percentage >= 50 then return icons.battery[60].text
  elseif percentage >= 30 then return icons.battery[40].text
  elseif percentage >= 15 then return icons.battery[20].text
  else return icons.battery[10].text end
end

local function get_battery_color(percentage, charging)
  if charging then return colors.green end
  if percentage < 15 then return colors.red
  elseif percentage < 30 then return colors.peach
  else return colors.sapphire end
end

local battery = sbar.add("item", "battery", {
  position = "right",
  update_freq = settings.update.battery,
  icon = {
    string = icons.battery[100].text,
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Medium"],
      size = settings.font_size.icon,
    },
    color = colors.sapphire,
    padding_left = 4,
    padding_right = 3,
  },
  label = {
    string = "100%",
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

local function update_battery()
  sbar.exec("pmset -g batt", function(output)
    local percentage = output:match("(%d+)%%")
    percentage = tonumber(percentage)
    
    if percentage == nil then return end
    
    local is_charging = output:match("charging") ~= nil or output:match("charged") ~= nil
    
    local icon = get_battery_icon(percentage, is_charging)
    local icon_color = get_battery_color(percentage, is_charging)
    
    battery:set({
      icon = { string = icon, color = icon_color },
      label = { string = string.format("%d%%", percentage) },
    })
  end)
end

battery:subscribe("routine", function(env) update_battery() end)
battery:subscribe("power_source_change", function(env) update_battery() end)
battery:subscribe("system_woke", function(env) update_battery() end)

battery:subscribe("mouse.entered", function(env)
  sbar.animate(settings.animation.easing, settings.animation.duration, function()
    battery:set({ label = { color = colors.sapphire } })
  end)
end)

battery:subscribe("mouse.exited", function(env)
  sbar.animate(settings.animation.easing, settings.animation.duration, function()
    battery:set({ label = { color = colors.text } })
  end)
end)

update_battery()

return battery
