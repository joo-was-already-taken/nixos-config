{ pkgs, ... }:

{
  imports = [
    ./stylix.nix
  ];

  stylix.icons = {
    enable = true;
    package = pkgs.papirus-icon-theme.override { color = "black"; };
    dark = "Papirus-Dark";
    light = "Papirus-Light";
  };

  stylix.targets = {
    gtk.enable = true;
    qt = {
      enable = true;
      platform = "qtct";
    };
  };
}
