{ config, ... }:

{
  flake.nixosModules.locale = { lib, ... }: {
    time.timeZone = lib.mkDefault config.flake.settings.timeZone;

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "pl_PL.UTF-8";
      LC_IDENTIFICATION = "pl_PL.UTF-8";
      LC_MEASUREMENT = "en_DK.UTF-8";
      LC_MONETARY = "pl_PL.UTF-8";
      LC_NAME = "pl_PL.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_DK.UTF-8";
      LC_TELEPHONE = "pl_PL.UTF-8";
      LC_TIME = "en_DK.UTF-8";
    };
  };
}
