{ pkgs, config, ... }:

{
  imports = [
    ../work/home.nix
  ];

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  # launch games with `gamemoderun %command%` for it to take an effect
  programs.gamemode.enable = true;

  home.packages = with pkgs; [
    # cpu, gpu, fps, etc. monitor
    mangohud

    protonup
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "${config.home.homeDirectory}/.steam/root/compatibilitytools.d";
  };
}
