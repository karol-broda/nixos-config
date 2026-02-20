{
  description = "karol's nix system (nixos + darwin)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-old-working.url = "github:NixOS/nixpkgs/20075955deac2583bb12f07151c2df830ef346b4";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-darwin = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    catppuccin.url = "github:catppuccin/nix";
    nixvim.url = "github:nix-community/nixvim";

    eza-themes = {
      url = "github:eza-community/eza-themes";
      flake = false;
    };

    catppuccin-userstyles.url = "github:catppuccin/userstyles";

    nixcord.url = "github:KaylorBen/nixcord";

    try = {
      url = "github:tobi/try";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snitch.url = "github:karol-broda/snitch";

    elephant.url = "github:abenz1267/elephant";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    mcp-servers = {
      url = "github:natsukium/mcp-servers-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    workmux.url = "github:raine/workmux";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-old-working,
    nix-darwin,
    home-manager,
    home-manager-darwin,
    catppuccin,
    nur,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    quickshell,
    ...
  } @ inputs: let
    username = "karolbroda";

    systemsList = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    eachSystem = nixpkgs.lib.genAttrs systemsList;

    mkPkgsUnstable = system:
      import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

    mkPkgsOldWorking = system:
      import nixpkgs-old-working {
        inherit system;
        config.allowUnfree = true;
      };

    overlayNur = nur.overlays.default;

    overlayPhosphor = final: prev: {
      phosphorIcons = prev.callPackage ./pkgs/phosphor-icons.nix {};
    };

    pkgsFor = system: import nixpkgs {inherit system;};
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs username;
        pkgs-unstable = mkPkgsUnstable "x86_64-linux";
        pkgs-old-working = mkPkgsOldWorking "x86_64-linux";
      };

      modules = [
        {nixpkgs.hostPlatform = "x86_64-linux";}
        ./hosts/nixos/configuration.nix

        {
          nixpkgs.overlays = [
            overlayNur
            overlayPhosphor
            quickshell.overlays.default
          ];
        }

        {
          nixpkgs.config.permittedInsecurePackages = [
            "ciscoPacketTracer8-8.2.2"
            "olm-3.2.16"
          ];
        }

        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";

          home-manager.extraSpecialArgs = {
            inherit inputs username;
            pkgs-unstable = mkPkgsUnstable "x86_64-linux";
          };

          home-manager.sharedModules = [
            inputs.spicetify-nix.homeManagerModules.spicetify
            inputs.catppuccin.homeModules.catppuccin
            inputs.nixvim.homeModules.nixvim
            inputs.nixcord.homeModules.nixcord
            inputs.plasma-manager.homeModules."plasma-manager"
            inputs.try.homeModules.default
            inputs.elephant.homeManagerModules.elephant
          ];

          home-manager.users.${username} = import ./home/karolbroda/nixos.nix;
        }
      ];
    };

    darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";

      specialArgs = {
        inherit inputs username;
      };

      modules = [
        ./hosts/darwin

        {
          nixpkgs.overlays = [
            overlayNur
            overlayPhosphor
          ];
        }

        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = username;
            autoMigrate = true;

            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };

            mutableTaps = true;
          };
        }

        home-manager-darwin.darwinModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";

          home-manager.extraSpecialArgs = {
            inherit inputs username;
            pkgs-unstable = mkPkgsUnstable "aarch64-darwin";
          };

          home-manager.sharedModules = [
            inputs.spicetify-nix.homeManagerModules.spicetify
            inputs.catppuccin.homeModules.catppuccin
            inputs.nixvim.homeModules.nixvim
            inputs.nixcord.homeModules.nixcord
            inputs.try.homeModules.default
          ];

          home-manager.users.${username} = import ./home/karolbroda/darwin.nix;
        }
      ];
    };

    devShells = eachSystem (
      system: let
        pkgs = pkgsFor system;
      in {
        default = pkgs.mkShell {
          packages = [
            pkgs.nixd
            pkgs.alejandra
            pkgs.kdePackages.qtdeclarative
          ];
        };
      }
    );

    formatter = eachSystem (
      system:
        (pkgsFor system).alejandra
    );
  };
}
