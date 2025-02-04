{ lib, pkgs, config, ... }:
let
  moduleName = "office";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modules.${moduleName}.enable {
    stylix.targets.zathura.enable = false;

    programs.zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
      };
    };

    home.packages = with pkgs; [
      libreoffice-qt
      # spellcheckers for libreoffice
      hunspell
      hunspellDicts.en-us
      hunspellDicts.pl_PL
    ];

    xdg = {
      desktopEntries = {
        zathura = {
          name = "Zathura";
          exec = "${config.programs.zathura.package}/bin/zathura";
        };
      };
    };
  };
}
