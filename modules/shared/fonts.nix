{
  config,
  pkgs,
  lib,
  system,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types optionalAttrs hasSuffix;
  cfg = config.personal.fonts;
  isLinux = hasSuffix "linux" system;
in {
  options.personal.fonts = {
    enable = mkEnableOption "system font configuration";

    fontconfig.enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable fontconfig for font discovery and configuration (nixos only)";
    };

    packages = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.monaspace
        noto-fonts
        noto-fonts-color-emoji
        noto-fonts-cjk-sans
        font-awesome
        material-symbols
        inter
      ];
      description = "font packages to install system-wide";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "additional font packages to install alongside the defaults";
    };
  };

  config = mkIf cfg.enable {
    fonts =
      {
        packages = cfg.packages ++ cfg.extraPackages;
      }
      // optionalAttrs isLinux {
        fontconfig.enable = cfg.fontconfig.enable;
      };
  };
}
