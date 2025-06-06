{ lib, pkgs, ... }:

{
  imports = [
    ../work/configuration.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];

  # launch games with `gamemoderun %command%` for it to take an effect
  programs.gamemode.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
    extraPackages = with pkgs; [
      # necessery for steam to launch
      glib
    ];
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  services.xserver.videoDrivers = [ "intel" "amdgpu" ];

  # # DLNA
  # services.minidlna = {
  #   enable = true;
  #   settings = {
  #     friendly_name = "nixdell-dlna";
  #     media_dir = [
  #       "A,/mnt/media/Music"
  #     ];
  #     log_level = "error";
  #     inotify = "yes";
  #   };
  # };
  # environment.systemPackages = [ pkgs.inotify-tools ];
  # users.users.minidlna = {
  #   extraGroups = [ "users" ];
  # };
}
