{ inputs, ... }:

let
  hostName = "vm";
  primaryUser = "vm-user";
  inherit (inputs.nixpkgs) lib;
in
{
  flake.settings = { inherit hostName primaryUser; };
  
  flake.nixosConfigurations.${hostName} = lib.nixosSystem {
    system = "x86_64-linux";
    modules = with inputs.self.nixosModules; [
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

        virtualisation.virtualbox.guest.enable = true;
        services.openssh.enable = true;

        services.xserver.xkb = {
          layout = "pl";
          variant = "";
        };
        console.keyMap = "pl2";

        users.users.joo = {
          isNormalUser = true;
          description = "joo";
          extraGroups = [ "networkmanager" "wheel" ];
          packages = with pkgs; [];
        };

        nixpkgs.config.allowUnfree = true;

        environment.systemPackages = with pkgs; [
          vim
        ];

        system.stateVersion = "25.11";
      })
    ];
  };
}
