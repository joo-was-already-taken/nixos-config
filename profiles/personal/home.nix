{ pkgs, lib, config, ... }@args:
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

    unstable.heroic # for EpicGames and GOG games
    bottles # for Windows apps
    dosbox # for MS DOS apps

    # games
    prismlauncher # minecraft
    superTuxKart
    vintagestory
  ];

  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "vintagestory"
      "jetbrains-toolbox"
    ];
    permittedInsecurePackages = [
      "dotnet-runtime-wrapped-7.0.20"
      "dotnet-runtime-7.0.20"
    ];
  };
}
