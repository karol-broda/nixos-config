{inputs, ...}: {
  _module.args = {
    username = "karolbroda";
    theme = import ../lib/theme.nix {inherit (inputs.nixpkgs) lib;};

    mkPkgsUnstable = system:
      import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
  };
}
