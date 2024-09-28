{
  description = "My first flake!";

  inputs = {
    # core inputs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # user inputs
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    systemSettings = {
      system = "x86_64-linux";
      hostName = "nixos";
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
        modules = [ (profilePath + "/configuration.nix") ];
        specialArgs = {
          inherit systemSettings userSettings;
        };
      };
    };

    homeConfigurations = {
      ${userSettings.userName} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ (profilePath + "/home.nix") ];
        extraSpecialArgs = {
          inherit systemSettings userSettings inputs;
        };
      };
    };
  };
}
