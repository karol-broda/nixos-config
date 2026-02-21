{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.personal.security.gnome-keyring;
in {
  options.personal.security.gnome-keyring = {
    enable = mkEnableOption "gnome keyring and secrets management";
  };

  config = mkIf cfg.enable {
    services = {
      gnome.gnome-keyring.enable = true;
      dbus.packages = [
        pkgs.gnome-keyring
        pkgs.gcr
      ];
    };

    security.pam.services = {
      login.enableGnomeKeyring = true;
      greetd.enableGnomeKeyring = true;
      hyprlock.enableGnomeKeyring = true;
      quickshell-lock = {};
    };

    programs = {
      seahorse.enable = true;
      ssh.startAgent = false;
    };
  };
}
