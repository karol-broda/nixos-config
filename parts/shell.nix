{
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      packages = [
        pkgs.nixd
        pkgs.alejandra
        pkgs.statix
        pkgs.deadnix
        pkgs.just
        pkgs.kdePackages.qtdeclarative
      ];
    };
  };
}
