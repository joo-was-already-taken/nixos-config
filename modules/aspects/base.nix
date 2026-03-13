{ lib, ... }:
{
  den.aspects.base = {
    includes = [
      ({ host, user }: {
        nixos.nix.settings.trusted-users = lib.mkIf user.trusted [ user.name ];

        nixos = {
          users.users.${user.name} = {
            isNormalUser = true;
            isSystemUser = false;
            initialPassword = user.name;
            group = user.name;
            extraGroups = lib.mkIf user.trusted [ "wheel" "networkmanager" ];
          };
          users.groups.${user.name} = {};
        };

        homeManager.home = {
          username = user.name;
          # homeDirectory = "/home/${user.name}";
          # stateVersion = host.stateVersion;
        };
      })
      ({ host, ... }: {
        nixos.system.stateVersion = host.stateVersion;
        homeManager.home.stateVersion = host.stateVersion;
      })
    ];

    nixos = { pkgs, lib, ... }: {
      programs.nano.enable = false;
      services.xserver = {
        enable = lib.mkDefault false;
        desktopManager.xterm.enable = false;
        excludePackages = [ pkgs.xterm ];
      };
      console.keyMap = "pl2";
      environment.systemPackages = with pkgs; [ vim git wget zip unzip ];
    };

    provides.nix = {
      nixos = {
        nix.settings = {
          experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
          keep-outputs = true;
          keep-derivations = true;
          auto-optimise-store = true;
          trusted-users = [ "root" ];
        };
        nix.daemonCPUSchedPolicy = "idle";
        nix.daemonIOSchedClass = "idle";
      };
      homeManager = { pkgs, ... }: {
        nix = {
          package = lib.mkDefault pkgs.nix;
          gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 30d";
          };
          settings.auto-optimise-store = true;
        };
      };
    };

    provides.locale = { host, ... }: {
      nixos = {
        time.timeZone = host.timeZone;
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
    };

    provides.networking = { host, ... }: {
      nixos = {
        networking.hostName = host.hostName;
        networking.networkmanager.enable = true;
        networking.firewall.enable = true;
      };
    };
  };
}
