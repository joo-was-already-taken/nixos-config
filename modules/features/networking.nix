{
  flake.modules.nixos.networking = { lib, settings, ... }: {
    networking.hostName = lib.mkDefault settings.hostName;
    networking.networkmanager.enable = true;
    networking.firewall.enable = true;
  };
}
