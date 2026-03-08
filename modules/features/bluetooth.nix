{
  flake.modules.nixos.bluetooth = {
    services.blueman.enable = true;
    hardware.bluetooth.enable = true;
  };
  flake.modules.homeManager.bluetooth = { pkgs, ... }: {
    home.packages = [ pkgs.bluez ];
  };
}
