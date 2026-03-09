{ inputs, withSystem, ... }@args:

let
  createHost = (import ./../_utils.nix args).createHost;
  bundles = import ../_bundles.nix;
  system = "x86_64-linux";
in {
  flake = withSystem system ({ self', ... }: createHost {
    inherit inputs system;
    name = "rednub";
    primaryUser = "joo";
    nixpkgs = inputs.nixpkgs-unstable;
    home-manager = inputs.home-manager-unstable;
    pkgs = self'.legacyPackages.unstable;
    stateVersion = "25.11";
    modules = bundles.core.modules ++ [ "neovim" ];
    extraNixosModules = [
      { imports = [ ./_hardware.nix ]; }
      {
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
      }
      { services.openssh.enable = true; }
    ];
  });
}
