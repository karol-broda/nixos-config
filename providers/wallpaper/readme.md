### elephant wallpaper provider

browse and set wallpapers from a configurable directory via hyprpaper.

#### features

- scans a wallpaper directory for image files (recursive, follows symlinks)
- fuzzy search by filename
- sets wallpapers via `hyprctl hyprpaper` with preloading (configurable)
- image preview support
- copy wallpaper path to clipboard
- refresh action to re-scan directory without restarting

#### actions

- `set` (default) — preload and set wallpaper via hyprpaper
- `copy_path` — copy the file path to clipboard
- `refresh` — re-scan the wallpaper directory

#### configuration

place in `~/.config/elephant/wallpaper.toml`:

```toml
directory = "~/Pictures/Wallpapers"
extensions = [".jpg", ".jpeg", ".png", ".gif", ".webp", ".bmp"]
set_command = "hyprctl hyprpaper preload %FILE% && hyprctl hyprpaper wallpaper ,%FILE%"
recursive = true
```

#### requirements

- `hyprctl` and `hyprpaper` for setting wallpapers (default)
- `wl-copy` for the copy path action
