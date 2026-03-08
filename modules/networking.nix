{ config, ... }:

{
  flake.nixosModules.networking = { lib, ... }: {
    networking.hostName = lib.mkDefault config.flake.settings.hostName;
    networking.networkmanager.enable = true;
  };
}
