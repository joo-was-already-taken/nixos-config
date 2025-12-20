{ lib, pkgs, config, ... }:
let
  moduleName = "librewolf";
  cfg = config.modules.${moduleName};

  librewolfSettings = ''
    defaultPref("webgl.disabled", false);
    defaultPref("content.protectedContent", true);
    defaultPref("privacy.resistFingerprinting", false);
    defaultPref("privacy.clearOnShutdown.history", false);
    defaultPref("privacy.clearOnShutdown.cookies", false);
    defaultPref("network.cookie.lifetimePolicy", 0);
    lockPref("browser.toolbars.bookmarks.visibility", "never");
    lockPref("browser.toolbars.bookmarks.showOtherBookmarks", false);
    lockPref("browser.toolbars.bookmarks.showInPrivateBrowsing", false);
  '';
  commonConfig = {
    stylix.targets.librewolf = {
      enable = true;
      profileNames = [ "default" ];
    };
  };
  nixpkgsConfig = {
    home.packages = [ pkgs.librewolf ];
    home.file.".librewolf/librewolf.overrides.cfg".text = librewolfSettings;
  };
  flatpakConfig = let
    librewolfId = "io.gitlab.librewolf-community";
  in {
    services.flatpak = {
      enable = true;
      packages = [ librewolfId ];
      overrides.${librewolfId} = {
        Environment.MOZ_ENABLE_WAYLAND = "1";
      };
    };
    home.file.".var/app/${librewolfId}/.librewolf/librewolf.overrides.cfg".text = librewolfSettings;
  };
in {
  options.modules.${moduleName} = {
    nixpkgs.enable = lib.mkEnableOption "enable nixpkgs version of ${moduleName}";
    flatpak.enable = lib.mkEnableOption "enable flatpak version of ${moduleName}";
  };

  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = !(cfg.nixpkgs.enable && cfg.flatpak.enable);
          message = "nixpkgs and flatpak versions of librewolf cannot coexist";
        }
      ];
    }
    commonConfig
    (lib.mkIf cfg.nixpkgs.enable nixpkgsConfig)
    (lib.mkIf cfg.flatpak.enable flatpakConfig)
  ];
}
