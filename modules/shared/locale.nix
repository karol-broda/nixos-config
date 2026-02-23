{
  config,
  lib,
  system,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types optionalAttrs hasSuffix;
  cfg = config.personal.locale;
  isLinux = hasSuffix "linux" system;
in {
  options.personal.locale = {
    enable = mkEnableOption "locale and timezone configuration";

    timeZone = mkOption {
      type = types.str;
      default = "Europe/Warsaw";
      description = "system timezone";
    };

    defaultLocale = mkOption {
      type = types.str;
      default = "en_US.UTF-8";
      description = "default system locale (nixos only)";
    };

    extraLocaleSettings = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "additional locale settings, e.g. LC_TIME, LC_MONETARY (nixos only)";
      example = {
        LC_TIME = "pl_PL.UTF-8";
        LC_MONETARY = "pl_PL.UTF-8";
      };
    };
  };

  config = mkIf cfg.enable ({
      time.timeZone = cfg.timeZone;
    }
    // optionalAttrs isLinux {
      i18n = {
        defaultLocale = cfg.defaultLocale;
        extraLocaleSettings = cfg.extraLocaleSettings;
      };
    });
}
