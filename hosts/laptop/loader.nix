{ ... }:

{
  boot.loader = {
      systemd-boot = {
      enable = true;
      configurationLimit = 8;
    };
    efi.canTouchEfiVariables = true;
    timeout = 2;
  };
}
