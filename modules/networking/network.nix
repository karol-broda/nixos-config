{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.personal.networking.network;
in {
  options.personal.networking.network = {
    enable = mkEnableOption "core networking configuration";

    hostName = mkOption {
      type = types.str;
      default = "nixos";
      description = "system hostname";
    };

    nameservers = mkOption {
      type = types.listOf types.str;
      default = [
        "1.1.1.1"
        "9.9.9.9"
      ];
      description = "dns nameservers";
    };

    hosts = mkOption {
      type = types.attrsOf (types.listOf types.str);
      default = {
        "127.0.0.1" = ["localhost"];
        "::1" = ["ip6-loopback"];
      };
      description = "static host entries";
    };

    networkmanager = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable networkmanager for network management";
      };

      dns = mkOption {
        type = types.str;
        default = "systemd-resolved";
        description = "dns backend for networkmanager";
      };
    };

    resolved.enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable systemd-resolved for dns resolution";
    };

    firewall = {
      allowedTCPPorts = mkOption {
        type = types.listOf types.port;
        default = [];
        description = "tcp ports to open in the firewall";
      };

      allowedUDPPorts = mkOption {
        type = types.listOf types.port;
        default = [];
        description = "udp ports to open in the firewall";
      };
    };
  };

  config = mkIf cfg.enable {
    networking = {
      hostName = cfg.hostName;
      nameservers = cfg.nameservers;
      hosts = cfg.hosts;

      networkmanager = {
        enable = cfg.networkmanager.enable;
        dns = cfg.networkmanager.dns;
      };

      firewall = {
        allowedTCPPorts = cfg.firewall.allowedTCPPorts;
        allowedUDPPorts = cfg.firewall.allowedUDPPorts;
      };
    };

    services.resolved.enable = cfg.resolved.enable;
  };
}
