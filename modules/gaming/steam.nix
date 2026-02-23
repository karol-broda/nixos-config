{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
in {
  options.personal.gaming.steam = {
    enable = mkEnableOption "steam gaming platform";

    openFirewalls = mkOption {
      type = types.bool;
      default = true;
      description = "open firewall ports for remote play, dedicated servers, and local network game transfers";
    };

    extraCompatPackages = mkOption {
      type = types.listOf types.package;
      default = [pkgs.proton-ge-bin];
      description = "additional compatibility tools for steam";
    };

    enableProtontricks = mkOption {
      type = types.bool;
      default = true;
      description = "enable protontricks for managing proton prefixes";
    };
  };

  config = mkIf config.personal.gaming.steam.enable {
    personal.packages.enable = lib.mkDefault true;

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = config.personal.gaming.steam.openFirewalls;
      dedicatedServer.openFirewall = config.personal.gaming.steam.openFirewalls;
      localNetworkGameTransfers.openFirewall = config.personal.gaming.steam.openFirewalls;
      extraCompatPackages = config.personal.gaming.steam.extraCompatPackages;
      protontricks.enable = config.personal.gaming.steam.enableProtontricks;
    };

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
      steam-hardware.enable = true;
    };
  };
}
