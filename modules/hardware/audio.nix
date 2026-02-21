{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.personal.hardware.audio;
in {
  options.personal.hardware.audio = {
    enable = mkEnableOption "pipewire audio stack";
  };

  config = mkIf cfg.enable {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      raopOpenFirewall = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };

      wireplumber = {
        enable = true;
        extraConfig = {
          "10-bluez" = {
            "monitor.bluez.properties" = {
              "bluez5.enable-sbc-xq" = true;
              "bluez5.enable-msbc" = true;
              "bluez5.enable-hw-volume" = true;
              "bluez5.codecs" = ["ldac" "aptx_hd" "aptx" "aac" "sbc_xq" "sbc"];
            };
          };

          "11-bluetooth-policy" = {
            "wireplumber.settings" = {
              "bluetooth.autoswitch-to-headset-profile" = false;
            };
          };
        };
      };

      extraConfig = {
        pipewire = {
          "10-defaults" = {
            "context.properties" = {
              "default.clock.allowed-rates" = [44100 48000 88200 96000];
              "default.clock.quantum" = 1024;
              "default.clock.min-quantum" = 32;
              "default.clock.max-quantum" = 2048;
            };
          };

          "20-raop-discover" = {
            "context.modules" = [
              {name = "libpipewire-module-raop-discover";}
            ];
          };
        };

        pipewire-pulse."10-resample" = {
          "stream.properties" = {
            "resample.quality" = 10;
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      pwvucontrol
      qpwgraph
      easyeffects
    ];
  };
}
