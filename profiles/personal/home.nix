{ pkgs, config, ... }@args:
let
  sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "${config.home.homeDirectory}/.steam/root/compatibilitytools.d";
  };
in {
  imports = [
    (import ../work/home.nix (args // { inherit sessionVariables; }))
  ];

  home.packages = with pkgs; [
    # cpu, gpu, fps, etc. monitor
    mangohud

    protonup

    # lutris
    heroic
    bottles
  ];
}
