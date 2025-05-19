{
  description = "My personal NixOS-and-HomeManager flake";

  inputs = {
    # core inputs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    # TODO: change to release-25.05 when it comes out
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # user inputs
    # pyprland.url = "github:hyprland-community/pyprland";
    pomidoro.url = "github:joo-was-already-taken/pomidoro";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, stylix, ... }@inputs:
    let
      systemSettings = {
        system = "x86_64-linux";
        hostName = "nixdell";
        profile = "personal";
        host = "laptop";
      };
      userSettings = {
        userName = "joo";
      };
      lib = nixpkgs.lib;
      myLib = import ./my-lib { inherit lib; };
      pkgs = import nixpkgs {
        system = systemSettings.system;
        overlays = [
          (final: prev: {
            unstable = nixpkgs-unstable.legacyPackages.${prev.system};
          })
        ];
      };
      profilePath = ./. + "/profiles" + ("/" + systemSettings.profile);
    in {
      nixosConfigurations = {
        ${systemSettings.hostName} = lib.nixosSystem {
          system = systemSettings.system;
          modules = [
            stylix.nixosModules.stylix
            # home-manager.nixosModules.home-manager
            (profilePath + "/configuration.nix")
            # {
            #   home-manager = {
            #     useGlobalPkgs = true;
            #     useUserPackages = true;
            #     users.${userSettings.userName}.imports = [
            #       (profilePath + "/home.nix")
            #     ];
            #     extraSpecialArgs = { inherit userSettings; };
            #   };
            # }
          ];
          specialArgs = {
            inherit inputs systemSettings userSettings;
          };
        };
      };

      homeConfigurations = {
        ${userSettings.userName} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            stylix.homeModules.stylix
            (profilePath + "/home.nix")
          ];
          extraSpecialArgs = let
            systemConfig = self.nixosConfigurations.${systemSettings.hostName}.config;
          in {
            inherit myLib inputs userSettings systemSettings systemConfig;
          };
        };
      };
    };
}
