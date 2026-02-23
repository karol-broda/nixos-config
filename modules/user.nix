{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.personal.user;
in {
  options.personal.user = {
    enable = mkEnableOption "primary user account configuration";

    shell = mkOption {
      type = types.package;
      default = pkgs.zsh;
      description = "default shell for the primary user";
    };

    extraGroups = mkOption {
      type = types.listOf types.str;
      default = [
        "wheel"
        "networkmanager"
        "audio"
        "video"
        "input"
      ];
      description = "groups the primary user belongs to";
    };

    noPasswdSudo = mkOption {
      type = types.bool;
      default = false;
      description = "allow the primary user to run sudo without a password";
    };

    linger = mkOption {
      type = types.bool;
      default = false;
      description = "enable lingering for the user (keeps user services running after logout)";
    };
  };

  config = mkIf cfg.enable {
    personal = {
      nix.enable = lib.mkDefault true;
      locale.enable = lib.mkDefault true;
      packages.enable = lib.mkDefault true;
    };

    users.users.${username} = {
      isNormalUser = true;
      extraGroups = cfg.extraGroups;
      shell = cfg.shell;
      linger = lib.mkDefault cfg.linger;
    };

    security.sudo.extraRules = mkIf cfg.noPasswdSudo [
      {
        users = [username];
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };
}
