{self, ...}: {
  perSystem = {pkgs, ...}: {
    checks = {
      nix-fmt = pkgs.runCommand "nix-fmt-check" {} ''
        ${pkgs.alejandra}/bin/alejandra --check ${self} > "$out"
      '';
    };
  };
}
