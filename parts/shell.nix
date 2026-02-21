{
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      packages = [
        pkgs.nixd
        pkgs.alejandra
        pkgs.kdePackages.qtdeclarative
      ];
    };
  };
}
