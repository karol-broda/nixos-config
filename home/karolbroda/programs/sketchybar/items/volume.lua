local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local function get_volume_icon(volume, muted)
  if muted or volume == 0 then return icons.volume.muted.text
  elseif volume < 33 then return icons.volume.low.text
  elseif volume < 66 then return icons.volume.medium.text
  else return icons.volume.high.text end
end

local volume = sbar.add("item", "volume", {
  position = "right",
  icon = {
    string = icons.volume.medium.text,
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Medium"],
      size = settings.font_size.icon,
    },
    color = colors.blue,
    padding_left = 4,
    padding_right = 3,
  },
  label = {
    string = "50%",
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

local function update_volume()
  sbar.exec("osascript -e 'output volume of (get volume settings)'", function(vol_output)
    local volume_level = tonumber(vol_output)
    
    if volume_level ~= nil then
      sbar.exec("osascript -e 'output muted of (get volume settings)'", function(mute_output)
        local is_muted = mute_output:match("true") ~= nil
        
        local icon = get_volume_icon(volume_level, is_muted)
        local icon_color = is_muted and colors.overlay0 or colors.blue
        local label_color = is_muted and colors.overlay0 or colors.text
        
        volume:set({
          icon = { string = icon, color = icon_color },
          label = { string = string.format("%d%%", volume_level), color = label_color },
        })
      end)
    end
  end)
end

volume:subscribe("volume_change", function(env)
  update_volume()
end)

volume:subscribe("mouse.clicked", function(env)
  sbar.exec("osascript -e 'set volume output muted not (output muted of (get volume settings))'")
  update_volume()
end)

volume:subscribe("mouse.entered", function(env)
  sbar.animate(settings.animation.easing, settings.animation.duration, function()
    volume:set({ label = { color = colors.blue } })
  end)
end)

volume:subscribe("mouse.exited", function(env)
  update_volume()
end)

update_volume()

return volume
