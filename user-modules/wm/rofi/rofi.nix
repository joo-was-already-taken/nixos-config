{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    rofi-wayland
  ];

  home.file.".config/rofi/config.rasi".source = config.lib.stylix.colors {
    template = ./config.rasi.mustache;
  };
}
