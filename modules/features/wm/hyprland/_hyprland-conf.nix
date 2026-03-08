{ moduleArgs, homeArgs }:

let
  inherit (moduleArgs.config.flake) capabilities;
  inherit (homeArgs) pkgs;
in
''
  debug:disable_logs = true
  ecosystem {
    no_update_news = true
    no_donation_nag = true
  }

  $mod = SUPER
  $terminal = ${capabilities.guiApps.terminal}
  $fileManager = ${capabilities.guiApps.fileManager}
  $browser = ${capabilities.guiApps.browser}

  $menu = ${pkgs.rofi}/bin/rofi -show drun -show-icons
  $commandMenu = ${pkgs.rofi}/bin/rofi -show run

  exec-once = ${pkgs.networkmanagerapplet}/bin/nm-applet &
  exec-once = (sleep 1; ${pkgs.blueman-applet}/bin/blueman-tray) &

  monitor = , preferred, auto, 1

  env
''
