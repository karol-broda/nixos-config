{pkgs, ...}: {
  "netbird-ui" = {
    Unit = {
      Description = "Netbird UI";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.netbird-ui}/bin/netbird-ui";
      Restart = "on-failure";
      RestartSec = 3;

      Environment = [
        "PATH=${pkgs.lib.makeBinPath [pkgs.dbus]}"
      ];
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
