{ lib, pkgs, config, ... }:
let
  moduleName = "music";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modules.${moduleName}.enable {
    home.packages = with pkgs; [
      tidal-dl
    ];

    programs.rmpc = {
      enable = true;
      config = builtins.readFile ./rmpc-config.ron;
    };

    services.mpd = {
      enable = true;
      musicDirectory = "$HOME/Music";
      extraConfig = ''
        audio_output {
          type       "pulse"
          name       "PulseAudio Output"
          mixer_type "software"
        }
      '';
    };
  };
}
