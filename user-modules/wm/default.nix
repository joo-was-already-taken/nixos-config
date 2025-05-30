{ lib, ... }@args:

{
  imports = [
    (import ./hyprland args)
    (import ./rofi args)
    ./waybar
    ./ironbar
  ];

  modules.hyprland.enable = lib.mkDefault true;
  modules.waybar.enable = lib.mkDefault false;
  modules.ironbar.enable = lib.mkDefault true;
  modules.rofi.enable = lib.mkDefault true;
}
