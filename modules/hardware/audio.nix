{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.personal.hardware.audio;
in {
  options.personal.hardware.audio = {
    enable = mkEnableOption "pipewire audio stack";

    pulse.enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable pulseaudio compatibility layer";
    };

    jack.enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable jack audio compatibility";
    };

    alsa = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable alsa support";
      };

      support32Bit = mkOption {
        type = types.bool;
        default = true;
        description = "enable 32-bit alsa support (needed for some games)";
      };
    };

    raop = mkOption {
      type = types.bool;
      default = true;
      description = "enable airplay (raop) streaming and open its firewall ports";
    };

    sampleRates = mkOption {
      type = types.listOf types.int;
      default = [44100 48000 88200 96000];
      description = "allowed audio sample rates";
    };

    quantum = {
      default = mkOption {
        type = types.int;
        default = 1024;
        description = "default buffer size in frames (higher = more latency, less cpu)";
      };

      min = mkOption {
        type = types.int;
        default = 32;
        description = "minimum buffer size";
      };

      max = mkOption {
        type = types.int;
        default = 2048;
        description = "maximum buffer size";
      };
    };

    resampleQuality = mkOption {
      type = types.int;
      default = 10;
      description = "pulseaudio stream resampling quality (0-14, higher = better quality)";
    };

    bluetoothCodecs = mkOption {
      type = types.listOf types.str;
      default = ["ldac" "aptx_hd" "aptx" "aac" "sbc_xq" "sbc"];
      description = "bluetooth audio codecs to enable in priority order";
    };

    bluetoothAutoHeadsetSwitch = mkOption {
      type = types.bool;
      default = false;
      description = "automatically switch to headset profile on voip";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [
        pwvucontrol
        qpwgraph
        easyeffects
      ];
      description = "audio management packages to install";
    };
  };

  config = mkIf cfg.enable {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      pulse.enable = cfg.pulse.enable;
      jack.enable = cfg.jack.enable;
      raopOpenFirewall = cfg.raop;

      alsa = {
        enable = cfg.alsa.enable;
        support32Bit = cfg.alsa.support32Bit;
      };

      wireplumber = {
        enable = true;
        extraConfig = {
          "10-bluez" = {
            "monitor.bluez.properties" = {
              "bluez5.enable-sbc-xq" = true;
              "bluez5.enable-msbc" = true;
              "bluez5.enable-hw-volume" = true;
              "bluez5.codecs" = cfg.bluetoothCodecs;
            };
          };

          "11-bluetooth-policy" = {
            "wireplumber.settings" = {
              "bluetooth.autoswitch-to-headset-profile" = cfg.bluetoothAutoHeadsetSwitch;
            };
          };
        };
      };

      extraConfig = {
        pipewire = {
          "10-defaults" = {
            "context.properties" = {
              "default.clock.allowed-rates" = cfg.sampleRates;
              "default.clock.quantum" = cfg.quantum.default;
              "default.clock.min-quantum" = cfg.quantum.min;
              "default.clock.max-quantum" = cfg.quantum.max;
            };
          };

          "20-raop-discover" = mkIf cfg.raop {
            "context.modules" = [
              {name = "libpipewire-module-raop-discover";}
            ];
          };
        };

        pipewire-pulse."10-resample" = {
          "stream.properties" = {
            "resample.quality" = cfg.resampleQuality;
          };
        };
      };
    };

    environment.systemPackages = cfg.extraPackages;
  };
}
