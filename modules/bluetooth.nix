{ ... }:
{
  flake.nixosModules.bluetooth = {
    services.blueman.enable = true;
    hardware.bluetooth.enable = true;
  };
  flake.homeModules.bluetooth = { pkgs, ... }: {
    home.packages = [ pkgs.bluez ];
  };
}
