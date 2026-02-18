local colors = {}

-- base tones
colors.base = 0xff303446
colors.mantle = 0xff292c3c
colors.crust = 0xff232634

-- surface tones
colors.surface0 = 0xff414559
colors.surface1 = 0xff51576d
colors.surface2 = 0xff626880

-- overlay tones
colors.overlay0 = 0xff737994
colors.overlay1 = 0xff838ba7
colors.overlay2 = 0xff949cbb

-- text hierarchy
colors.text = 0xffc6d0f5
colors.subtext1 = 0xffb5bfe2
colors.subtext0 = 0xffa5adce

-- accent palette
colors.rosewater = 0xfff2d5cf
colors.flamingo = 0xffeebebe
colors.pink = 0xfff4b8e4
colors.mauve = 0xffca9ee6
colors.red = 0xffe78284
colors.maroon = 0xffea999c
colors.peach = 0xffef9f76
colors.yellow = 0xffe5c890
colors.green = 0xffa6d189
colors.teal = 0xff81c8be
colors.sky = 0xff99d1db
colors.sapphire = 0xff85c1dc
colors.blue = 0xff8caaee
colors.lavender = 0xffbabbf1

-- primary accent
colors.accent = colors.lavender
colors.accent_secondary = colors.mauve
colors.accent_tertiary = colors.sapphire

-- semantic colors
colors.success = colors.green
colors.warning = colors.yellow
colors.error = colors.red
colors.info = colors.blue

colors.bar = 0x00000000
colors.bar_border = colors.transparent

colors.island = 0xee303446
colors.island_border = 0x30626880

-- popup styling
colors.popup_bg = 0xf0303446
colors.popup_border = colors.surface2

-- item backgrounds
colors.item_bg = 0x00000000
colors.item_bg_hover = 0x40414559
colors.item_bg_active = 0x60414559

-- workspace states
colors.ws_active_bg = colors.lavender
colors.ws_active_fg = colors.base
colors.ws_occupied_bg = 0x40414559
colors.ws_occupied_fg = colors.subtext1
colors.ws_empty_fg = colors.overlay0

-- shadows and transparency
colors.transparent = 0x00000000
colors.shadow = 0x80000000

-- bracket/group backgrounds (used inside islands)
colors.bracket_bg = 0x00000000

colors.with_alpha = function(color, alpha)
  if alpha > 1.0 or alpha < 0.0 then return color end
  return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
end

return colors
