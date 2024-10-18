{ lib, ... }@args:

{
  imports = [
    (import ./hyprland args)
    ./waybar
    ./rofi
  ];

  modules.hyprland.enable = lib.mkDefault true;
  modules.waybar.enable = lib.mkDefault true;
  modules.rofi.enable = lib.mkDefault true;
}
