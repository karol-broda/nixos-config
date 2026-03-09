{lib}: {
  colors = import ./colors.nix;
  icons = import ./icons.nix;
  ansi = import ./ansi.nix {inherit lib;};
}
