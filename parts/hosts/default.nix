{inputs, ...}: {
  imports = [
    ./nixos.nix
    ./darwin.nix
  ];

  _module.args = {
    commonOverlays = [
      inputs.nur.overlays.default
      inputs.self.overlays.customPkgs
    ];

    sharedHomeModules = [
      inputs.spicetify-nix.homeManagerModules.spicetify
      inputs.catppuccin.homeModules.catppuccin
      inputs.nixvim.homeModules.nixvim
      inputs.nixcord.homeModules.nixcord
      inputs.try.homeModules.default
      inputs.zen-browser.homeModules.default
    ];
  };
}
