{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption getExe;
  cfg = config.personal.programs.packettracer;
  packetTracerEval = builtins.tryEval pkgs.ciscoPacketTracer8;
  packetTracerPkg =
    if packetTracerEval.success == true
    then packetTracerEval.value
    else null;
in {
  options.personal.programs.packettracer = {
    enable = mkEnableOption "cisco packet tracer (firejailed)";
  };

  config = mkIf (cfg.enable && packetTracerEval.success == true) {
    programs.firejail = {
      enable = true;

      wrappedBinaries = {
        packettracer8 = {
          executable = getExe packetTracerPkg;
          desktop = "${packetTracerPkg}/share/applications/cisco-pt8.desktop.desktop";

          extraArgs = [
            "--net=none"
            "--noprofile"
            ''--env=QT_STYLE_OVERRIDE=""''
          ];
        };
      };
    };
  };
}
