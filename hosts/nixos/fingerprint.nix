{pkgs, ...}: let
  libfprintTodFpc = pkgs.callPackage ../../pkgs/libfprint-2-tod1-fpc.nix {};
in {
  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = libfprintTodFpc;
    };
  };

  security.pam.services = {
    login.fprintAuth = true;
    sudo.fprintAuth = true;
    polkit-1.fprintAuth = true;
  };

  environment.systemPackages = with pkgs; [
    fprintd
  ];
}
