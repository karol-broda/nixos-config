{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
in {
  options.gaming.steam = {
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

  config = mkIf config.gaming.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = config.gaming.steam.openFirewalls;
      dedicatedServer.openFirewall = config.gaming.steam.openFirewalls;
      localNetworkGameTransfers.openFirewall = config.gaming.steam.openFirewalls;

      extraCompatPackages = config.gaming.steam.extraCompatPackages;
      protontricks.enable = config.gaming.steam.enableProtontricks;
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    hardware.steam-hardware.enable = true;
  };
}
