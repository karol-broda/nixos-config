{pkgs, ...}: {
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;

    extraConfig.pipewire."10-defaults" = {
      "context.properties" = {
        "default.clock.allowed-rates" = [44100 48000 88200 96000];
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 2048;
      };
    };

    extraConfig.pipewire-pulse."10-resample" = {
      "stream.properties" = {
        "resample.quality" = 10;
      };
    };

    extraConfig.pipewire."20-raop-discover" = {
      "context.modules" = [
        {name = "libpipewire-module-raop-discover";}
      ];
    };

    raopOpenFirewall = true;

    wireplumber.extraConfig = {
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

  environment.systemPackages = with pkgs; [
    pwvucontrol
    qpwgraph
    easyeffects
  ];
}
