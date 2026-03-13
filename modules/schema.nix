{ inputs, ... }:
{
  den.schema.host = { host, lib, ... }: let
    inherit (lib) types;
  in {
    options.stateVersion = lib.mkOption {
      type = types.str;
      description = "When this machine was first built";
    };

    options.timeZone = lib.mkOption {
      type = types.str;
      default = "UTC";
      description = "System time zone";
    };
    config.timeZone = lib.mkDefault "Europe/Warsaw";

    options.channel = lib.mkOption {
      type = types.enum [ "unstable" "stable" ];
      description = "Which channel to use for this host";
    };
    config.channel = lib.mkDefault "unstable";

    config.instantiate = lib.mkDefault
      inputs."nixpkgs-${host.channel}".lib.nixosSystem;
    config.home-manager.module = lib.mkDefault
      inputs."home-manager-${host.channel}"."${host.class}Modules".home-manager;
  };

  den.schema.user = { user, lib, ... }: let
    inherit (lib) types;
  in {
    config.classes = lib.mkDefault [ "nixos" "homeManager" ];

    options.trusted = lib.mkOption { type = types.bool; };
    config.trusted = lib.mkDefault false;

    options.university = {
      enable = lib.mkOption {
        type = types.bool;
        description = "Enable university stuff";
      };
      dir = lib.mkOption {
        type = types.functionTo types.str;
        description = "Directory with university stuff";
      };
    };
    config.university.enable = lib.mkDefault false;
    config.university.dir = lib.mkDefault (homeDir: "${homeDir}/wisdom/pw");
  };
}
