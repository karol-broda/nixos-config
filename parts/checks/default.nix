{self, ...}: {
  perSystem = {pkgs, ...}: {
    checks = {
      nix-fmt = pkgs.runCommand "nix-fmt-check" {} ''
        ${pkgs.alejandra}/bin/alejandra --check ${self} > "$out"
      '';

      statix = pkgs.runCommand "statix-check" {} ''
        ${pkgs.statix}/bin/statix check ${self} > "$out"
      '';

      deadnix = pkgs.runCommand "deadnix-check" {} ''
        ${pkgs.deadnix}/bin/deadnix --fail ${self} > "$out"
      '';
    };
  };
}
