local colors = require("colors")
local settings = require("settings")

local spaces = {}

local function update_space(space_id)
  sbar.exec("aerospace list-workspaces --focused", function(focused_output)
    local focused = focused_output:match("^%s*(.-)%s*$")
    
    sbar.exec("aerospace list-workspaces --all --empty no", function(occupied_output)
      local has_windows = {}
      for workspace in occupied_output:gmatch("[^\r\n]+") do
        local trimmed = workspace:match("^%s*(.-)%s*$")
        if trimmed ~= nil and trimmed ~= "" then
          has_windows[trimmed] = true
        end
      end
      
      for _, ws in ipairs(settings.aerospace.workspaces) do
        if space_id == nil or space_id == ws then
          local is_focused = (focused == ws)
          local has_window = has_windows[ws] or false
          
          local icon_color = colors.ws_empty_fg
          local bg_color = colors.transparent
          
          if is_focused then
            icon_color = colors.ws_active_fg
            bg_color = colors.ws_active_bg
          elseif has_window then
            icon_color = colors.ws_occupied_fg
            bg_color = colors.ws_occupied_bg
          end
          
          sbar.animate(settings.animation.easing, settings.animation.duration, function()
            spaces["space." .. ws]:set({
              icon = { color = icon_color },
              background = { color = bg_color, drawing = is_focused or has_window },
            })
          end)
        end
      end
    end)
  end)
end

for i, ws in ipairs(settings.aerospace.workspaces) do
  local space = sbar.add("item", "space." .. ws, {
    position = "left",
    update_freq = i == 1 and 5 or 0,
    icon = {
      string = ws,
      font = {
        family = settings.font.mono,
        style = settings.font.style_map["Semibold"],
        size = settings.font_size.workspace,
      },
      color = colors.ws_empty_fg,
      padding_left = 6,
      padding_right = 6,
    },
    label = { drawing = false },
    background = {
      color = colors.transparent,
      corner_radius = 5,
      height = 18,
      drawing = false,
    },
    padding_left = 1,
    padding_right = 1,
    click_script = "aerospace workspace " .. ws .. " && sketchybar --trigger aerospace_workspace_change",
  })
  
  space:subscribe("mouse.entered", function(env)
    sbar.exec("aerospace list-workspaces --focused", function(output)
      local focused = output:match("^%s*(.-)%s*$")
      if focused ~= ws then
        sbar.animate(settings.animation.easing, settings.animation.duration, function()
          space:set({
            icon = { color = colors.text },
            background = { color = colors.item_bg_hover, drawing = true },
          })
        end)
      end
    end)
  end)
  
  space:subscribe("mouse.exited", function(env)
    update_space(ws)
  end)
  
  spaces["space." .. ws] = space
end

sbar.add("event", "aerospace_workspace_change")
sbar.add("event", "space_windows_change")

local first_space = spaces["space." .. settings.aerospace.workspaces[1]]

first_space:subscribe("aerospace_workspace_change", function(env)
  update_space(nil)
end)

first_space:subscribe("space_windows_change", function(env)
  update_space(nil)
end)

first_space:subscribe("routine", function(env)
  update_space(nil)
end)

update_space(nil)

return spaces
