{theme, ...}: let
  inherit (theme) colors icons ansi;

  inherit (colors) flamingo pink mauve red maroon peach yellow green teal sky sapphire blue;
  inherit (colors) subtext0 overlay0 surface2;

  r = ansi.reset;
  inherit (ansi) esc fg padRight lightDashes heavyDashes;

  # all lines (borders, rows, dividers) must total boxInnerWidth + 2 visible chars
  boxInnerWidth = 38;

  mkBorder = {
    left,
    label,
    right,
    color,
  }: let
    labelLen = builtins.stringLength label;
    dashCount = boxInnerWidth - 5 - labelLen;
    dim = fg overlay0;
  in "${dim}${left}─ ${r}${fg color} ${label} ${r} ${dim}${lightDashes dashCount}${right}${r}";

  mkDivider = {
    label,
    color,
  }: let
    labelLen = builtins.stringLength label;
    dashCount = boxInnerWidth - 5 - labelLen;
    accent = fg color;
  in "${accent}╞═  ${label}  ${heavyDashes dashCount}╡${r}";

  mkKey = {
    icon,
    label,
    color,
  }: let
    padded = padRight 9 label;
  in "{$1}  {##${color}}${icon}{##${subtext0}}  ${padded}{##${surface2}}·";

  kittyLogo = ''
    ${esc}[38;2;202;158;230m       ,${esc}[0m
    ${esc}[38;2;201;159;230m       `-._           __${esc}[0m
    ${esc}[38;2;200;160;230m        \  `-..____,.'  `.${esc}[0m
    ${esc}[38;2;200;161;231m         :`.         /    `.${esc}[0m
    ${esc}[38;2;199;162;231m         :  )       :      : \${esc}[0m
    ${esc}[38;2;199;163;232m          ;'        '   ;  |  :${esc}[0m
    ${esc}[38;2;198;164;232m          )..      .. .:.`.;  :${esc}[0m
    ${esc}[38;2;197;165;232m         /::...  .:::...   ` ;${esc}[0m
    ${esc}[38;2;197;166;233m         ; _ '    __        /:\${esc}[0m
    ${esc}[38;2;196;167;233m         `:o>   /\o_>      ;:. `.${esc}[0m
    ${esc}[38;2;195;169;234m        `-`.__ ;   __..--- /:.   \${esc}[0m
    ${esc}[38;2;194;170;234m        === \_/   ;=====_.':.     ;${esc}[0m
    ${esc}[38;2;194;171;235m         ,/'`--'...`--....        ;${esc}[0m
    ${esc}[38;2;193;173;235m              ;                    ;${esc}[0m
    ${esc}[38;2;193;174;236m            .'                      ;${esc}[0m
    ${esc}[38;2;192;175;236m          .'                        ;${esc}[0m
    ${esc}[38;2;191;176;236m        .'     ..     ,      .       ;${esc}[0m
    ${esc}[38;2;191;177;237m       :       ::..  /      ;::.     |${esc}[0m
    ${esc}[38;2;190;178;237m      /      `.;::.  |       ;:..    ;${esc}[0m
    ${esc}[38;2;190;179;238m     :         |:.   :       ;:.    ;${esc}[0m
    ${esc}[38;2;189;180;238m     :         ::     ;:..   |.    ;${esc}[0m
    ${esc}[38;2;188;181;238m      :       :;      :::....|     |${esc}[0m
    ${esc}[38;2;188;182;239m      /\     ,/ \      ;:::::;     ;${esc}[0m
    ${esc}[38;2;187;183;239m    .:. \:..|    :     ; '.--|     ;${esc}[0m
    ${esc}[38;2;187;184;240m   ::.  :''''  `-.,,;     ;'   ;     ;${esc}[0m
    ${esc}[38;2;186;185;240m.-'. _.'\.     / `;      \,__:      \${esc}[0m
    ${esc}[38;2;186;187;241m`---'    `----'   ;      /    \,.,,,/${esc}[0m
    ${esc}[38;2;186;187;241m                   `----`${esc}[0m
  '';

  # draws both │ borders then moves cursor back so key content fills the gap
  rowWrapper = "│${esc}[${toString boxInnerWidth}C│${esc}[${toString boxInnerWidth}D";
in {
  programs.fastfetch = {
    enable = true;

    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

      logo = {
        type = "data-raw";
        source = kittyLogo;
        padding = {
          top = 0;
          right = 2;
          left = 0;
          bottom = 0;
        };
      };

      display = {
        separator = " ";
        color = {
          keys = "#${overlay0}";
          separator = "#${surface2}";
        };
        size = {
          binaryPrefix = "si";
        };
        constants = [rowWrapper];
      };

      modules = [
        "break"
        "break"

        {
          type = "custom";
          format = mkBorder {
            left = "╭";
            label = "system";
            right = "╮";
            color = mauve;
          };
        }
        {
          type = "title";
          key = mkKey {
            icon = icons.account;
            label = "user";
            color = mauve;
          };
          format = "{##${blue}}{user-name}{##${overlay0}}@{##${blue}}{host-name}";
        }
        {
          type = "os";
          key = mkKey {
            icon = icons.nix;
            label = "os";
            color = blue;
          };
          format = "{name}";
        }
        {
          type = "kernel";
          key = mkKey {
            icon = icons.cog;
            label = "kernel";
            color = sapphire;
          };
          format = "{release}";
        }
        {
          type = "packages";
          key = mkKey {
            icon = icons.package;
            label = "packages";
            color = sky;
          };
          format = "{all}";
        }
        {
          type = "uptime";
          key = mkKey {
            icon = icons.clockOutline;
            label = "uptime";
            color = green;
          };
          format = "{?days}{days}d {?}{hours}h {minutes}m";
        }

        {
          type = "custom";
          format = mkDivider {
            label = "session";
            color = teal;
          };
        }
        {
          type = "shell";
          key = mkKey {
            icon = icons.bash;
            label = "shell";
            color = teal;
          };
          format = "{pretty-name}";
        }
        {
          type = "terminal";
          key = mkKey {
            icon = icons.console;
            label = "term";
            color = green;
          };
          format = "{pretty-name}";
        }
        {
          type = "wm";
          key = mkKey {
            icon = icons.monitorDash;
            label = "wm";
            color = sapphire;
          };
          format = "{pretty-name}";
        }
        {
          type = "player";
          key = mkKey {
            icon = icons.musicNote;
            label = "player";
            color = pink;
          };
          format = "{player}";
        }
        {
          type = "media";
          key = mkKey {
            icon = icons.music;
            label = "song";
            color = flamingo;
          };
          format = "{?title}{title}{?}";
        }
        {
          type = "media";
          key = mkKey {
            icon = icons.microphone;
            label = "artist";
            color = maroon;
          };
          format = "{?artist}{artist}{?}";
        }
        {
          type = "media";
          key = mkKey {
            icon = icons.album;
            label = "album";
            color = mauve;
          };
          format = "{?album}{album}{?}";
        }

        {
          type = "custom";
          format = mkDivider {
            label = "hardware";
            color = peach;
          };
        }
        {
          type = "cpu";
          key = mkKey {
            icon = icons.chip;
            label = "cpu";
            color = peach;
          };
          format = "{name:20}";
        }
        {
          type = "gpu";
          key = mkKey {
            icon = icons.memory;
            label = "gpu";
            color = red;
          };
          format = "{name:20}";
        }
        {
          type = "memory";
          key = mkKey {
            icon = icons.database;
            label = "memory";
            color = yellow;
          };
          format = "{used} / {total}";
        }
        {
          type = "disk";
          key = mkKey {
            icon = icons.harddisk;
            label = "disk";
            color = maroon;
          };
          format = "{size-used} / {size-total}";
        }
        {
          type = "display";
          key = mkKey {
            icon = icons.monitor;
            label = "monitor";
            color = flamingo;
          };
          format = "{width}x{height}{?refresh-rate} @ {refresh-rate}Hz{?}";
        }

        {
          type = "custom";
          format = mkDivider {
            label = "clock";
            color = yellow;
          };
        }
        {
          type = "datetime";
          key = mkKey {
            icon = icons.calendar;
            label = "date";
            color = yellow;
          };
          format = "{year}-{month-pretty}-{day-pretty}";
        }
        {
          type = "datetime";
          key = mkKey {
            icon = icons.clock;
            label = "time";
            color = peach;
          };
          format = "{hour-pretty}:{minute-pretty}:{second-pretty}";
        }

        {
          type = "colors";
          key = mkKey {
            icon = icons.palette;
            label = "palette";
            color = pink;
          };
          symbol = "circle";
        }

        {
          type = "custom";
          format = "${fg overlay0}╰${lightDashes boxInnerWidth}╯${r}";
        }
      ];
    };
  };
}
