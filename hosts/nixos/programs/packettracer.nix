{
  pkgs,
  lib,
  ...
}: let
  packetTracerEval = builtins.tryEval pkgs.ciscoPacketTracer8;
  packetTracerPkg =
    if packetTracerEval.success == true
    then packetTracerEval.value
    else null;
in {
  programs.firejail = lib.mkIf (packetTracerEval.success == true) {
    enable = true;

    wrappedBinaries = {
      packettracer8 = {
        executable = lib.getExe packetTracerPkg;
        desktop = "${packetTracerPkg}/share/applications/cisco-pt8.desktop.desktop";

        extraArgs = [
          "--net=none"
          "--noprofile"
          ''--env=QT_STYLE_OVERRIDE=""''
        ];
      };
    };
  };
}
