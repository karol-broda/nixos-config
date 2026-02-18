from __future__ import annotations
import argparse
import os
import sys
from typing import List, Sequence, Tuple

ASCII_ART: str = (
    r"""
       ,
       \`-._           __
        \\  `-..____,.'  `.
         :`.         /    \`.
         :  )       :      : \
          ;'        '   ;  |  :
          )..      .. .:.`.;  :
         /::...  .:::...   ` ;
         ; _ '    __        /:\
         `:o>   /\o_>      ;:. `.
        `-`.__ ;   __..--- /:.   \
        === \_/   ;=====_.':.     ;
         ,/'`--'...`--....        ;
              ;                    ;
            .'                      ;
          .'                        ;
        .'     ..     ,      .       ;
       :       ::..  /      ;::.     |
      /      `.;::.  |       ;:..    ;
     :         |:.   :       ;:.    ;
     :         ::     ;:..   |.    ;
      :       :;      :::....|     |
      /\     ,/ \      ;:::::;     ;
    .:. \:..|    :     ; '.--|     ;
   ::.  :''''  `-.,,;     ;'   ;     ;
.-'. _.'\      / `;      \,__:      \
`---'    `----'   ;      /    \,.,,,/
                   `----`
""".lstrip(
        "\n"
    )
)


def hex_to_rgb(value: str) -> Tuple[int, int, int]:
    if value is None:
        raise ValueError("hex color is required")
    text = value.strip()
    if text.startswith("#"):
        text = text[1:]
    if len(text) != 6 or any(c not in "0123456789abcdefABCDEF" for c in text):
        raise ValueError(f"invalid hex color: {value}")
    r = int(text[0:2], 16)
    g = int(text[2:4], 16)
    b = int(text[4:6], 16)
    return (r, g, b)


def lerp_rgb(
    a: Tuple[int, int, int], b: Tuple[int, int, int], t: float
) -> Tuple[int, int, int]:
    if t < 0.0:
        t = 0.0
    if t > 1.0:
        t = 1.0
    ar, ag, ab = a
    br, bg, bb = b
    return (int(ar + (br - ar) * t), int(ag + (bg - ag) * t), int(ab + (bb - ab) * t))


def ansi_fg(rgb: Tuple[int, int, int]) -> str:
    r, g, b = rgb
    return f"\x1b[38;2;{r};{g};{b}m"


RESET: str = "\x1b[0m"


def gradient_horizontal(
    line: str, start: Tuple[int, int, int], end: Tuple[int, int, int]
) -> str:
    length = len(line)
    if length == 0:
        return ""
    chunks: List[str] = []
    for i, ch in enumerate(line):
        t = 0.0 if length <= 1 else i / float(length - 1)
        rgb = lerp_rgb(start, end, t)
        chunks.append(ansi_fg(rgb) + ch)
    return "".join(chunks) + RESET


def gradient_vertical(
    lines: Sequence[str], start: Tuple[int, int, int], end: Tuple[int, int, int]
) -> List[str]:
    count = len(lines)
    if count == 0:
        return []
    out: List[str] = []
    for i, line in enumerate(lines):
        t = 0.0 if count <= 1 else i / float(count - 1)
        rgb = lerp_rgb(start, end, t)
        out.append(ansi_fg(rgb) + line + RESET)
    return out


def render_art(art_text: str, start_hex: str, end_hex: str, mode: str) -> str:
    start_rgb = hex_to_rgb(start_hex)
    end_rgb = hex_to_rgb(end_hex)
    lines = art_text.splitlines()
    if mode == "horizontal":
        colored_lines = [
            gradient_horizontal(line, start_rgb, end_rgb) for line in lines
        ]
    elif mode == "vertical":
        colored_lines = gradient_vertical(lines, start_rgb, end_rgb)
    else:
        raise ValueError("mode must be 'horizontal' or 'vertical'")
    return "\n".join(colored_lines)


def parse_args(argv: Sequence[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="generate a kitty ascii logo with a catppuccin frappe gradient"
    )
    parser.add_argument(
        "--start",
        default="#ca9ee6",
        help="start hex color (default: #ca9ee6)",
    )
    parser.add_argument(
        "--end",
        default="#babbf1",
        help="end hex color (default: #babbf1)",
    )
    parser.add_argument(
        "--mode",
        choices=("horizontal", "vertical"),
        default="horizontal",
        help="gradient mode: horizontal (per char) or vertical (per line)",
    )
    parser.add_argument(
        "--out", default="-", help="output file path, or '-' for stdout (default: '-')"
    )
    return parser.parse_args(argv)


def main(argv: Sequence[str]) -> int:
    try:
        args = parse_args(argv)
        output = render_art(
            art_text=ASCII_ART, start_hex=args.start, end_hex=args.end, mode=args.mode
        )
        if args.out is not None and args.out != "-":
            parent = os.path.dirname(args.out)
            if parent:
                os.makedirs(parent, exist_ok=True)
            with open(args.out, "w", encoding="utf-8", newline="\n") as f:
                f.write(output)
        else:
            sys.stdout.write(output)
        return 0
    except Exception as exc:
        sys.stderr.write(f"error: {exc}\n")
        return 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
