{
  config,
  lib,
  username,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.personal.programs.wireshark;
in {
  options.personal.programs.wireshark = {
    enable = mkEnableOption "wireshark network analyzer";
  };

  config = mkIf cfg.enable {
    programs.wireshark.enable = true;

    users.users.${username} = {
      extraGroups = ["wireshark"];
    };
  };
}
