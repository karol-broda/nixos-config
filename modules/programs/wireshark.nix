{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.personal.programs.wireshark;
in {
  options.personal.programs.wireshark = {
    enable = mkEnableOption "wireshark network analyzer";

    usbmon = mkOption {
      type = types.bool;
      default = false;
      description = "permit wireshark group members to capture usb traffic via udev rules";
    };

    termshark = mkOption {
      type = types.bool;
      default = true;
      description = "install termshark, a terminal-based tui for tshark";
    };
  };

  config = mkIf cfg.enable {
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark; # Qt GUI; nixos default is wireshark-cli
      usbmon.enable = cfg.usbmon;
    };

    users.users.${username}.extraGroups = ["wireshark"];

    environment.systemPackages = lib.optionals cfg.termshark [pkgs.termshark];
  };
}
