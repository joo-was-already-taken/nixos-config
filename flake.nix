{
  description = "My personal NixOS-and-HomeManager flake";

  inputs = {
    # core inputs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-mineral.url = "github:cynicsketch/nix-mineral";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    # user inputs
    neovim-penultimum.url = "github:joo-was-already-taken/neovim-penultimum";

    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # pyprland.url = "github:hyprland-community/pyprland";
    # pomidoro.url = "github:joo-was-already-taken/pomidoro";
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
      pkgs = import nixpkgs {
        system = systemSettings.system;
        config.allowUnfreePredicate = unfreePredicate;
        overlays = [
          (final: prev: {
            unstable = import nixpkgs-unstable {
              system = systemSettings.system;
              config.allowUnfreePredicate = unfreePredicate;
            };
            llvm = prev.llvm.overrideAttrs (oldAttrs: {
              doCheck = false;
            });
          })
        ];
      };
      myLib = import ./my-lib { inherit lib pkgs; };
      unfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "jetbrains-toolbox"
        "codeium"
        "widevine-cdm"
      ];
      profilePath = ./. + "/profiles" + ("/" + systemSettings.profile);
    in {
      nixosConfigurations = {
        ${systemSettings.hostName} = lib.nixosSystem {
          system = systemSettings.system;
          modules = [
            inputs.nix-mineral.nixosModules.nix-mineral
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
            inputs.nix-flatpak.homeManagerModules.nix-flatpak
            inputs.neovim-penultimum.homeManagerModules.default
            inputs.nix-doom-emacs-unstraightened.homeModule
            (profilePath + "/home.nix")
          ];
          extraSpecialArgs = let
            systemConfig = self.nixosConfigurations.${systemSettings.hostName}.config;
          in {
            inherit myLib inputs userSettings systemSettings systemConfig;
          };
        };
      };

      devShells.${systemSettings.system}.default = pkgs.mkShell {
        packages = with pkgs; [
          nil
          bash-language-server
          lua-language-server
        ];
      };
    };
}
