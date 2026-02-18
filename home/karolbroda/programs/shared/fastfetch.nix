{lib, ...}: let
  accent = "#babbf1";

  esc = builtins.fromJSON ''"\u001b"'';

  boxInnerWidth = 38;

  dashes = n: lib.strings.concatStrings (lib.lists.genList (_: "─") n);

  mkHeader = {
    left,
    label,
    right,
  }: let
    labelLen = builtins.stringLength label;
    dashCount = boxInnerWidth - 5 - labelLen;
  in "${left}─╴ ${label} ╶${dashes dashCount}${right}";

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
          top = 1;
          right = 2;
          left = 0;
          bottom = 0;
        };
      };

      display = {
        separator = " ";
        color = {
          keys = accent;
          separator = accent;
        };
        size = {
          binaryPrefix = "si";
        };
        constants = [rowWrapper];
      };

      modules = [
        "break"

        {
          type = "custom";
          format = mkHeader {
            left = "╭";
            label = "system";
            right = "╮";
          };
        }
        {
          type = "title";
          key = "{$1}   ";
          format = "{user-name}@{host-name}";
        }

        {
          type = "custom";
          format = mkHeader {
            left = "├";
            label = "basics";
            right = "┤";
          };
        }
        {
          type = "os";
          key = "{$1}    os       ·";
          format = "{name}";
        }
        {
          type = "kernel";
          key = "{$1}    kernel   ·";
          format = "{release}";
        }
        {
          type = "packages";
          key = "{$1}    packages ·";
          format = "{all}";
        }
        {
          type = "uptime";
          key = "{$1}  󰔟  uptime   ·";
          format = "{?days}{days}d {?}{hours}h {minutes}m";
        }

        {
          type = "custom";
          format = mkHeader {
            left = "├";
            label = "session";
            right = "┤";
          };
        }
        {
          type = "shell";
          key = "{$1}  󰮯  shell    ·";
          format = "{pretty-name}";
        }
        {
          type = "terminal";
          key = "{$1}  󰆍  term     ·";
          format = "{pretty-name}";
        }
        {
          type = "wm";
          key = "{$1}  󰨇  wm       ·";
          format = "{pretty-name}";
        }

        {
          type = "custom";
          format = mkHeader {
            left = "├";
            label = "hardware";
            right = "┤";
          };
        }
        {
          type = "cpu";
          key = "{$1}    cpu      ·";
          format = "{name:20}";
        }
        {
          type = "gpu";
          key = "{$1}  󰍛  gpu      ·";
          format = "{name:20}";
        }
        {
          type = "memory";
          key = "{$1}  󰑭  memory   ·";
          format = "{used}/{total}";
        }
        {
          type = "display";
          key = "{$1}  󰍹  monitor  ·";
          format = "{width}x{height}";
        }

        {
          type = "custom";
          format = mkHeader {
            left = "├";
            label = "media";
            right = "┤";
          };
        }
        {
          type = "player";
          key = "{$1}  󰎈  player   ·";
          format = "{name:20}";
        }
        {
          type = "media";
          key = "{$1}  󰝚  media    ·";
          format = "{combined:20}";
        }

        {
          type = "custom";
          format = mkHeader {
            left = "├";
            label = "clock";
            right = "┤";
          };
        }
        {
          type = "datetime";
          key = "{$1}  󰃭  date     ·";
          format = "{year}-{month-pretty}-{day-pretty}";
        }
        {
          type = "datetime";
          key = "{$1}  󰅐  time     ·";
          format = "{hour-pretty}:{minute-pretty}:{second-pretty}";
        }

        {
          type = "custom";
          format = mkHeader {
            left = "├";
            label = "colors";
            right = "┤";
          };
        }
        {
          type = "colors";
          key = "{$1}   ";
          symbol = "circle";
        }

        {
          type = "custom";
          format = mkHeader {
            left = "╰";
            label = "end";
            right = "╯";
          };
        }
      ];
    };
  };
}
