{ inputs, withSystem, ... }:

let
  settings = {
    hostName = "rednub";
    primaryUser = "joo";
    timeZone = "Europe/Warsaw";
  };
  system = "x86_64-linux";
  inherit (inputs.nixpkgs-unstable) lib;
in
{
  flake.nixosConfigurations.${settings.hostName} = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs settings; };
    modules = with inputs.self.modules.nixos; [
      nix
      locale
      networking
      ({ pkgs, ... }: {
        imports = [ ./_hardware.nix ];

        boot.loader.grub = {
          enable = true;
          device = "/dev/sda";
          useOSProber = true;
        };

        services.logind = {
          lidSwitch = "ignore";
          lidSwitchExternalPower = "ignore";
          lidSwitchDocked = "ignore";
        };

        services.xserver.xkb = {
          layout = "pl";
          variant = "";
        };
        console.keyMap = "pl2";

        users.users.${settings.primaryUser} = {
          isNormalUser = true;
          description = settings.primaryUser;
          extraGroups = [ "networkmanager" "wheel" ];
          packages = with pkgs; [];
        };

        services.openssh.enable = true;

        nixpkgs.config.allowUnfree = true;

        environment.systemPackages = with pkgs; [
          vim
          git
        ];

        system.stateVersion = "25.11";
      })
    ];
  };

  flake.homeConfigurations.${settings.primaryUser} = withSystem system ({ self', ... }:
    inputs.home-manager-unstable.lib.homeManagerConfiguration {
      pkgs = self'.legacyPackages.unstable;
      modules = with inputs.self.modules.homeManager; [
        git
        tmux
        {
          programs.home-manager.enable = true;
          home = rec {
            username = settings.primaryUser;
            homeDirectory = "/home/${username}";
            stateVersion = "25.11";
          };
        }
      ];
    });
}
