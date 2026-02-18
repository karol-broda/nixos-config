{pkgs, ...}: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    package = pkgs.docker_28;
    liveRestore = true;
    extraPackages = [
      pkgs.dive
    ];
    autoPrune = {
      enable = true;
      dates = "weekly";
      randomizedDelaySec = "30min";
      persistent = true;
      flags = ["--all" "--volumes"];
    };
    # rootless = {
    #   enable = true;
    #   setSocketVariable = true;
    # };
  };

  users.users.karolbroda = {
    extraGroups = ["docker"];
    linger = true;
  };
}
