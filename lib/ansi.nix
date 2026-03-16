# ansi escape code helpers and terminal string utilities
{lib}: let
  esc = builtins.fromJSON ''"\u001b"'';

  # hex string to r;g;b for ansi color codes
  hexDigitValue = c:
    if c == "0"
    then 0
    else if c == "1"
    then 1
    else if c == "2"
    then 2
    else if c == "3"
    then 3
    else if c == "4"
    then 4
    else if c == "5"
    then 5
    else if c == "6"
    then 6
    else if c == "7"
    then 7
    else if c == "8"
    then 8
    else if c == "9"
    then 9
    else if c == "a"
    then 10
    else if c == "b"
    then 11
    else if c == "c"
    then 12
    else if c == "d"
    then 13
    else if c == "e"
    then 14
    else if c == "f"
    then 15
    else 0;

  hexByte = s: let
    hi = hexDigitValue (builtins.substring 0 1 s);
    lo = hexDigitValue (builtins.substring 1 1 s);
  in
    hi * 16 + lo;

  hexToRgb = hex: let
    r = hexByte (builtins.substring 0 2 hex);
    g = hexByte (builtins.substring 2 2 hex);
    b = hexByte (builtins.substring 4 2 hex);
  in "${toString r};${toString g};${toString b}";
in {
  inherit esc hexToRgb;

  fg = color: "${esc}[38;2;${hexToRgb color}m";
  reset = "${esc}[0m";

  padRight = width: str: let
    len = builtins.stringLength str;
    padCount =
      if width > len
      then width - len
      else 0;
    padding = lib.strings.concatStrings (lib.lists.genList (_: " ") padCount);
  in "${str}${padding}";

  lightDashes = n: lib.strings.concatStrings (lib.lists.genList (_: "─") n);
  heavyDashes = n: lib.strings.concatStrings (lib.lists.genList (_: "═") n);
}
