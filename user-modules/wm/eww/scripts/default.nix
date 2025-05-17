{ pkgs, ... }:
rec {
  hyprFullscreenMode = pkgs.writeShellApplication {
    name = "hypr-fullscreenmode";
    text = builtins.readFile ./hypr-fullscreenmode.sh;
  };
  hyprListen = pkgs.writeShellApplication {
    name = "hypr-listen";
    runtimeInputs = [ pkgs.socat hyprFullscreenMode ];
    text = builtins.readFile ./hypr-listen.sh;
  };
  battery = pkgs.writeShellApplication {
    name = "battery";
    text = builtins.readFile ./battery.sh;
  };
}
