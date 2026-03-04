{
  config,
  lib,
  system,
  ...
}: let
  inherit (lib) mkIf mkMerge mkEnableOption mkOption types hasSuffix;
  cfg = config.personal.networking.network;
  perfCfg = cfg.performance;
  isLinux = hasSuffix "linux" system;
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

      wifi.powersave = mkOption {
        type = types.bool;
        default = false;
        description = "enable wifi power saving (degrades throughput and latency significantly)";
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

    performance = {
      enable = mkEnableOption "kernel-level network performance tuning (linux only)";

      bbr = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "use bbr congestion control instead of cubic";
        };

        qdisc = mkOption {
          type = types.str;
          default = "fq_codel";
          description = "packet scheduler; fq_codel works on both wifi and ethernet, fq adds pacing for bbr but destroys wifi frame aggregation throughput";
        };
      };

      buffers = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "raise tcp/socket buffer limits to 16 mb (defaults cap at 4 mb)";
        };

        rmemMax = mkOption {
          type = types.int;
          default = 16777216;
          description = "maximum receive socket buffer size in bytes";
        };

        wmemMax = mkOption {
          type = types.int;
          default = 16777216;
          description = "maximum send socket buffer size in bytes";
        };
      };

      fastopen = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "enable tcp fast open for client and server connections";
        };
      };

      tuning = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "apply general tcp behaviour tweaks (idle slow start, mtu probing, metrics caching)";
        };

        netdevMaxBacklog = mkOption {
          type = types.int;
          default = 16384;
          description = "max packets queued on the input side when the interface receives faster than the kernel processes";
        };
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [
        {
          assertion = perfCfg.enable -> isLinux;
          message = "personal.networking.network.performance requires linux; it sets kernel sysctls that do not exist on darwin";
        }
      ];

      networking = {
        hostName = cfg.hostName;
        nameservers = cfg.nameservers;
        hosts = cfg.hosts;

        networkmanager = {
          enable = cfg.networkmanager.enable;
          dns = cfg.networkmanager.dns;
          wifi.powersave = cfg.networkmanager.wifi.powersave;
        };

        firewall = {
          allowedTCPPorts = cfg.firewall.allowedTCPPorts;
          allowedUDPPorts = cfg.firewall.allowedUDPPorts;
        };
      };

      services.resolved.enable = cfg.resolved.enable;
    }

    (mkIf (perfCfg.enable && perfCfg.bbr.enable) {
      boot.kernelModules = ["tcp_bbr"];

      boot.kernel.sysctl = {
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.core.default_qdisc" = perfCfg.bbr.qdisc;
      };
    })

    (mkIf (perfCfg.enable && perfCfg.buffers.enable) {
      boot.kernel.sysctl = {
        "net.core.rmem_max" = perfCfg.buffers.rmemMax;
        "net.core.wmem_max" = perfCfg.buffers.wmemMax;
        "net.ipv4.tcp_rmem" = "4096 1048576 ${toString perfCfg.buffers.rmemMax}";
        "net.ipv4.tcp_wmem" = "4096 65536 ${toString perfCfg.buffers.wmemMax}";
      };
    })

    (mkIf (perfCfg.enable && perfCfg.fastopen.enable) {
      boot.kernel.sysctl = {
        # bitmask: 1 = client, 2 = server, 3 = both
        "net.ipv4.tcp_fastopen" = 3;
      };
    })

    (mkIf (perfCfg.enable && perfCfg.tuning.enable) {
      boot.kernel.sysctl = {
        "net.core.netdev_max_backlog" = perfCfg.tuning.netdevMaxBacklog;
        "net.ipv4.tcp_slow_start_after_idle" = 0;
        "net.ipv4.tcp_mtu_probing" = 1;
        "net.ipv4.tcp_no_metrics_save" = 1;
      };
    })
  ]);
}
