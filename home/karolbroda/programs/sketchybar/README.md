# sketchybar

catppuccin frappe theme with lavender accents, lua-based, phosphor svg icons.

## features

- **left**: apple logo, aerospace workspaces (1-9, 0), current app
- **right**: cpu/memory graphs, volume, battery, date/time  
- **interactive**: click workspaces, volume slider, battery popup
- **theme**: catppuccin frappe + lavender

## installation

managed by nix-darwin services + home-manager for config files.

```bash
darwin-rebuild switch --flake ~/.config/nix-config
```

## structure

**system services** (`hosts/darwin/services/`)
- `sketchybar.nix` - service + jankyborders
- `aerospace.nix` - window manager with event triggers

**home-manager** (`home/karolbroda/programs/darwin/`)
- `sketchybar.nix` - symlinks config and phosphor icons

**config** (`home/karolbroda/programs/sketchybar/`)
- `colors.lua` - catppuccin frappe palette
- `icons.lua` - phosphor svg paths
- `settings.lua` - customization options
- `items/*.lua` - bar items

## customization

edit `settings.lua`:

```lua
-- change accent color
colors.accent = colors.mauve  -- or .pink, .blue, etc.

-- toggle items
settings.features = {
  show_cpu = true,
  show_memory = true,
  -- ...
}

-- adjust update rates
settings.update = {
  cpu = 2,        -- seconds
  memory = 3,
  battery = 10,
}
```

then rebuild:
```bash
darwin-rebuild switch --flake ~/.config/nix-config
```

## usage

- **workspaces**: click to switch, hover for highlight
- **volume**: click for slider, right-click to mute  
- **battery**: click for detailed info
- **calendar**: click to open Calendar.app

## credits

- [sketchybar](https://github.com/FelixKratz/SketchyBar)
- [sbarlua](https://github.com/FelixKratz/SbarLua)
- [catppuccin](https://github.com/catppuccin/catppuccin)
- [phosphor icons](https://phosphoricons.com/)
