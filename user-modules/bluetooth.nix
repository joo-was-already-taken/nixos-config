{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bluez
  ];

  # requires `services.blueman.enable = true;` to be set system-wide
  services.blueman-applet.enable = true;
}
