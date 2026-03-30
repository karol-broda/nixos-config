{
  config,
  pkgs-old-working,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption getExe;
  cfg = config.personal.programs.packettracer;

  requiredSource = pkgs-old-working.requireFile {
    name = "CiscoPacketTracer822_amd64_signed.deb";
    hash = "sha256-bNK4iR35LSyti2/cR0gPwIneCFxPP+leuA1UUKKn9y0=";
    url = "https://www.netacad.com";
  };
  sourceAvailable = builtins.pathExists (builtins.unsafeDiscardStringContext "${requiredSource}");

  packetTracerPkg = pkgs-old-working.ciscoPacketTracer8;
in {
  options.personal.programs.packettracer = {
    enable = mkEnableOption "cisco packet tracer (firejailed)";
  };

  config = mkIf cfg.enable (
    if sourceAvailable
    then {
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
    }
    else {
      warnings = [
        "packettracer: CiscoPacketTracer822_amd64_signed.deb is not in the nix store, skipping. Download it from https://www.netacad.com and run: nix-prefetch-url file:///path/to/CiscoPacketTracer822_amd64_signed.deb"
      ];
    }
  );
}
