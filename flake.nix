{
  description = "My personal NixOS-and-HomeManager flake";

  inputs = {
    # core inputs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # user inputs
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, ... }@inputs:
    let
      systemSettings = {
        system = "x86_64-linux";
        hostName = "nixdell";
        profile = "work";
        host = "laptop";
      };
      userSettings = {
        userName = "joo";
      };
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${systemSettings.system};
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
            inherit systemSettings userSettings;
          };
        };
      };

      homeConfigurations = {
        ${userSettings.userName} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            stylix.homeManagerModules.stylix
            (profilePath + "/home.nix")
          ];
          extraSpecialArgs = {
            inherit userSettings systemSettings;
          };
        };
      };
    };
}
