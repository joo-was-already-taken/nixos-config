{ lib, ... }@args:

{
  imports = [
    (import ./hyprland args)
    ./waybar
    ./rofi
    ./eww
  ];

  modules.hyprland.enable = lib.mkDefault true;
  modules.waybar.enable = lib.mkDefault true;
  modules.rofi.enable = lib.mkDefault true;
  modules.eww.enable = lib.mkDefault true;
}
