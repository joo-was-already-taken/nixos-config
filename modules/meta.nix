{ lib,... }:

let
  inherit (lib) types;
in
{
  options.flake.settings = {
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

    university.enable = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Enable university stuff";
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
