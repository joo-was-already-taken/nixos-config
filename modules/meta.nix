{ lib,... }:

let
  inherit (lib) types;
in
{
  options.flake.settings = {
    hostName = lib.mkOption {
      type = types.str;
      description = "Name of a host machine";
    };
    primaryUser = lib.mkOption {
      type = types.str;
      description = "The main user account name";
    };
    timeZone = lib.mkOption {
      type = types.str;
      default = "Europe/Warsaw";
    };

    guiApps = {
      terminal = lib.mkOption {
        type = types.str;
        description = "Preferred terminal emulator";
      };
      browser = lib.mkOption {
        type = types.str;
        description = "Preferred web browser";
      };
      fileManager = lib.mkOption {
        type = types.str;
        description = "Preferred file manager";
      };
    };
  };

  options.flake.capabilities = {
    gui = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Whether there is GUI available";
    };
  };
}
