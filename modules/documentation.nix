{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.personal.documentation;
in {
  options.personal.documentation = {
    enable = mkEnableOption "system documentation (man pages, dev docs)";

    man = mkOption {
      type = types.bool;
      default = true;
      description = "enable man pages";
    };

    dev = mkOption {
      type = types.bool;
      default = true;
      description = "enable developer documentation (headers, api references)";
    };

    doc = mkOption {
      type = types.bool;
      default = true;
      description = "enable general documentation";
    };

    nixos = mkOption {
      type = types.bool;
      default = false;
      description = "enable nixos manual and option docs (adds build time)";
    };

    info = mkOption {
      type = types.bool;
      default = false;
      description = "enable gnu info pages";
    };
  };

  config = mkIf cfg.enable {
    documentation = {
      enable = true;
      man.enable = cfg.man;
      dev.enable = cfg.dev;
      doc.enable = cfg.doc;
      nixos.enable = cfg.nixos;
      info.enable = cfg.info;
    };
  };
}
