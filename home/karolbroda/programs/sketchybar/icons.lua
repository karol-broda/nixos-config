local home = os.getenv("HOME")
local phosphor_path = home .. "/.config/assets/phosphor-icons"

local icons = {}

local function phosphor(name, weight)
  weight = weight or "regular"
  local filename = weight == "regular" and name .. ".svg" or name .. "-" .. weight .. ".svg"
  return phosphor_path .. "/" .. weight .. "/" .. filename
end

icons.apple = {
  svg = phosphor("apple-logo", "fill"),
  text = "󰀵",
  sf = "",
}

icons.space = {}
for i = 0, 9 do
  icons.space[i] = tostring(i)
end

icons.window = {
  svg = phosphor("app-window", "regular"),
  text = "",
  sf = "􀏝",
}

icons.fullscreen = {
  svg = phosphor("arrows-out", "bold"),
  text = "󰊓",
  sf = "􀏜",
}

icons.cpu = {
  svg = phosphor("cpu", "regular"),
  text = "󰻠",
  sf = "􀫥",
}

icons.memory = {
  svg = phosphor("memory", "regular"),
  text = "󰍛",
  sf = "􀫦",
}

icons.disk = {
  svg = phosphor("hard-drives", "regular"),
  text = "󰋊",
  sf = "􀨭",
}

icons.temp = {
  svg = phosphor("thermometer", "regular"),
  text = "󰔄",
  sf = "􀇬",
}

icons.network = {
  upload = {
    svg = phosphor("arrow-up", "bold"),
    text = "󰕒",
    sf = "􀄨",
  },
  download = {
    svg = phosphor("arrow-down", "bold"),
    text = "󰇚",
    sf = "􀄩",
  },
  wifi = {
    svg = phosphor("wifi-high", "fill"),
    text = "󰖩",
    sf = "􀙇",
  },
  wifi_off = {
    svg = phosphor("wifi-slash", "regular"),
    text = "󰖪",
    sf = "􀙈",
  },
  ethernet = {
    svg = phosphor("ethernet", "regular"),
    text = "󰈀",
    sf = "􀆪",
  },
}

icons.volume = {
  high = {
    svg = phosphor("speaker-high", "fill"),
    text = "󰕾",
    sf = "􀊩",
  },
  medium = {
    svg = phosphor("speaker-low", "fill"),
    text = "󰖀",
    sf = "􀊧",
  },
  low = {
    svg = phosphor("speaker-simple-low", "fill"),
    text = "󰕿",
    sf = "􀊥",
  },
  muted = {
    svg = phosphor("speaker-simple-slash", "fill"),
    text = "󰝟",
    sf = "􀊣",
  },
}

icons.battery = {
  [100] = {
    svg = phosphor("battery-full", "fill"),
    text = "󰁹",
    sf = "􀛨",
  },
  [90] = {
    svg = phosphor("battery-high", "fill"),
    text = "󰂂",
    sf = "􀺸",
  },
  [80] = {
    svg = phosphor("battery-high", "fill"),
    text = "󰂁",
    sf = "􀺸",
  },
  [70] = {
    svg = phosphor("battery-medium", "fill"),
    text = "󰂀",
    sf = "􀺶",
  },
  [60] = {
    svg = phosphor("battery-medium", "fill"),
    text = "󰁿",
    sf = "􀺶",
  },
  [50] = {
    svg = phosphor("battery-medium", "fill"),
    text = "󰁾",
    sf = "􀺶",
  },
  [40] = {
    svg = phosphor("battery-low", "fill"),
    text = "󰁽",
    sf = "􀛩",
  },
  [30] = {
    svg = phosphor("battery-low", "fill"),
    text = "󰁼",
    sf = "􀛩",
  },
  [20] = {
    svg = phosphor("battery-low", "fill"),
    text = "󰁻",
    sf = "􀛩",
  },
  [10] = {
    svg = phosphor("battery-empty", "fill"),
    text = "󰁺",
    sf = "􀛪",
  },
  [0] = {
    svg = phosphor("battery-empty", "fill"),
    text = "󰂎",
    sf = "􀛪",
  },
  charging = {
    svg = phosphor("battery-charging", "fill"),
    text = "󰂄",
    sf = "􀢋",
  },
}

icons.calendar = {
  svg = phosphor("calendar-blank", "regular"),
  text = "󰃭",
  sf = "􀉉",
}

icons.clock = {
  svg = phosphor("clock", "regular"),
  text = "󰥔",
  sf = "􀐫",
}

icons.media = {
  play = {
    svg = phosphor("play", "fill"),
    text = "󰐊",
    sf = "􀊄",
  },
  pause = {
    svg = phosphor("pause", "fill"),
    text = "󰏤",
    sf = "􀊆",
  },
  next = {
    svg = phosphor("skip-forward", "fill"),
    text = "󰒭",
    sf = "􀊐",
  },
  prev = {
    svg = phosphor("skip-back", "fill"),
    text = "󰒮",
    sf = "􀊎",
  },
  shuffle = {
    svg = phosphor("shuffle", "bold"),
    text = "󰒝",
    sf = "􀊝",
  },
  repeat_all = {
    svg = phosphor("repeat", "bold"),
    text = "󰑖",
    sf = "􀊞",
  },
  repeat_one = {
    svg = phosphor("repeat-once", "bold"),
    text = "󰑘",
    sf = "􀊟",
  },
}

icons.terminal = {
  svg = phosphor("terminal-window", "regular"),
  text = "",
  sf = "􀩼",
}

icons.browser = {
  svg = phosphor("browser", "regular"),
  text = "󰈹",
  sf = "􀎭",
}

icons.code = {
  svg = phosphor("code", "regular"),
  text = "󰨞",
  sf = "􀤆",
}

icons.chat = {
  svg = phosphor("chat-circle-text", "fill"),
  text = "󰭹",
  sf = "􀌤",
}

icons.music = {
  svg = phosphor("music-notes", "fill"),
  text = "󰎆",
  sf = "􀑬",
}

icons.mail = {
  svg = phosphor("envelope", "regular"),
  text = "󰇮",
  sf = "􀍖",
}

icons.finder = {
  svg = phosphor("folder", "fill"),
  text = "󰀶",
  sf = "􀈕",
}

icons.loading = {
  svg = phosphor("circle-notch", "bold"),
  text = "󰔟",
  sf = "􀖇",
}

icons.check = {
  svg = phosphor("check", "bold"),
  text = "󰄬",
  sf = "􀆅",
}

icons.alert = {
  svg = phosphor("warning", "fill"),
  text = "󰀪",
  sf = "􀇿",
}

icons.error = {
  svg = phosphor("x-circle", "fill"),
  text = "󰅚",
  sf = "􀙟",
}

icons.info = {
  svg = phosphor("info", "fill"),
  text = "󰋽",
  sf = "􀅴",
}

icons.arrow = {
  up = {
    svg = phosphor("arrow-up", "bold"),
    text = "",
    sf = "􀄨",
  },
  down = {
    svg = phosphor("arrow-down", "bold"),
    text = "",
    sf = "􀄩",
  },
  left = {
    svg = phosphor("arrow-left", "bold"),
    text = "",
    sf = "􀄪",
  },
  right = {
    svg = phosphor("arrow-right", "bold"),
    text = "",
    sf = "􀄫",
  },
}

icons.chevron = {
  up = {
    svg = phosphor("caret-up", "fill"),
    text = "",
    sf = "􀆃",
  },
  down = {
    svg = phosphor("caret-down", "fill"),
    text = "",
    sf = "􀆈",
  },
  left = {
    svg = phosphor("caret-left", "fill"),
    text = "",
    sf = "􀆉",
  },
  right = {
    svg = phosphor("caret-right", "fill"),
    text = "",
    sf = "􀆊",
  },
}

icons.settings = {
  svg = phosphor("gear", "regular"),
  text = "󰒓",
  sf = "􀣋",
}

icons.power = {
  svg = phosphor("power", "bold"),
  text = "󰐥",
  sf = "􀆨",
}

icons.lock = {
  svg = phosphor("lock", "fill"),
  text = "󰌾",
  sf = "􀎠",
}

icons.unlock = {
  svg = phosphor("lock-open", "fill"),
  text = "󰌿",
  sf = "􀎡",
}

icons.bluetooth = {
  on = {
    svg = phosphor("bluetooth", "fill"),
    text = "󰂯",
    sf = "􀟓",
  },
  off = {
    svg = phosphor("bluetooth-slash", "fill"),
    text = "󰂲",
    sf = "􀟒",
  },
}

icons.bell = {
  svg = phosphor("bell", "fill"),
  text = "󰂚",
  sf = "􀋚",
}

icons.search = {
  svg = phosphor("magnifying-glass", "bold"),
  text = "󰍉",
  sf = "􀊫",
}

icons.download = {
  svg = phosphor("download", "bold"),
  text = "󰇚",
  sf = "􀈭",
}

icons.upload = {
  svg = phosphor("upload", "bold"),
  text = "󰕒",
  sf = "􀈯",
}

icons.trash = {
  svg = phosphor("trash", "regular"),
  text = "󰩺",
  sf = "􀈑",
}

icons.separator = {
  text = "│",
  sf = "│",
}

return icons
