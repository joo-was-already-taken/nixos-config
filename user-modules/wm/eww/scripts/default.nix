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

  hyprWorkspaces = pkgs.writeShellApplication {
    name = "hypr-workspaces";
    runtimeInputs = [ pkgs.socat ];
    text = builtins.readFile ./hypr-workspaces.sh;
  };

  battery = pkgs.writeShellApplication {
    name = "battery";
    text = builtins.readFile ./battery.sh;
  };

  pulseVolume = pkgs.stdenv.mkDerivation {
    name = "pulse-volume-listener";
    propagatedBuildInputs = [
      (pkgs.python3.withPackages (ps: with ps; [
        pulsectl
        pulsectl-asyncio
      ]))
    ];
    dontUnpack = true;
    installPhase = ''
      install -Dm755 ${./pulse-volume-listener.py} $out/bin/pulse-volume-listener
    '';
  };
}
