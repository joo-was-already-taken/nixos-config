{ pkgs, ... }:

{
  imports = [
    ./stylix.nix
  ];

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override {
        color = "black";
      };
    };
  };

  # stylix.targets.qt.enable = true; # TODO: wait for stabilization
  qt = {
    enable = true;
    # platformTheme.name = "qt5ct";
    # style.name = "kvantum";
  };
}
