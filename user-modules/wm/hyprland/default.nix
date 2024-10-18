{ lib, ... }@args:

{
  imports = [
    (import ./hyprland.nix args)
  ];

  modules.hyprland.enable = lib.mkDefault true;
}
