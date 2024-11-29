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

  # nixpkgs.config.allowUnfreePredicate = pkg:
  #   builtins.elem (lib.getName pkg) [
  #     "minecraft-launcher"
  #   ];

  # nixpkgs.config.allowBroken = true;
  # nixpkgs.config.allowBrokenPredicate = pkg:
  #   builtins.elem (lib.getName pkg) [
  #     "minecraft-launcher"
  #   ];

  home.packages = with pkgs; [
    # cpu, gpu, fps, etc. monitor
    mangohud

    protonup

    heroic
    bottles

    # games
    prismlauncher # minecraft
  ];
}
