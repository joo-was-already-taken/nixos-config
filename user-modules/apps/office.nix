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
        first-page-column = "2";
      };
    };

    home.packages = with pkgs; [
      libreoffice-qt
      # spellcheckers for libreoffice
      hunspell
      hunspellDicts.en-us
      hunspellDicts.pl_PL
      hunspellDicts.de_DE
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
