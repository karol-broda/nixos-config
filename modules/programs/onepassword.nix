{
  config,
  lib,
  pkgs-unstable,
  username,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.personal.programs.onepassword;
in {
  options.personal.programs.onepassword = {
    enable = mkEnableOption "1password password manager";
  };

  config = mkIf cfg.enable {
    programs = {
      _1password.enable = true;
      _1password-gui = {
        enable = true;
        package = pkgs-unstable._1password-gui;
        polkitPolicyOwners = [username];
      };
    };

    environment.etc = {
      "1password/custom-allowed-browsers/zen-beta".text = "";
      "1password/custom-allowed-browsers/.zen-beta-wrapped".text = "";
    };
  };
}
