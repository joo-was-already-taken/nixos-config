{ pkgs, lib, config, userSettings, inputs, sessionVariables ? {}, ... }@args:
let
  workSessionVars = {
    EDITOR = "nvim";
    MANPAGER = "nvim --remote -c 'Man!' -o -";
    FILEMANAGER = "nemo";
    TERMINAL = "alacritty";
    BROWSER = "qutebrowser";
  }
    // (if config.modules.hyprland.enable then { NIXOS_OZONE_WL = "1"; } else {})
    // sessionVariables;
in {
  imports = [
    ../../styling/home-style.nix
    inputs.sops-nix.homeManagerModules.sops
    (import ../../user-modules/sh (args // { sessionVariables = workSessionVars; }))
    ../../user-modules/dev.nix
    ../../user-modules/bluetooth.nix
    ../../user-modules/virtualization.nix
    ../../user-modules/apps
    (import ../../user-modules/wm (args // { sessionVariables = workSessionVars; }))
  ];

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "zathura.desktop";

        "text/html" = "qutebrowser.desktop";
        "x-scheme-handler/http" = "qutebrowser.desktop";
        "x-scheme-handler/https" = "qutebrowser.desktop";
        "x-scheme-handler/about" = "qutebrowser.desktop";
        "x-scheme-handler/unknown" = "qutebrowser.desktop";
      };
    };
  };

  services.gammastep = {
    enable = true;
    tray = true;
    # dawnTime = "5:00-6:00";
    # duskTime = "19:00-20:00";
    latitude = 52.23;
    longitude = 21.01;
    settings.general = {
      temp-night = lib.mkForce 3200;
    };
  };

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "/home/${userSettings.userName}/.config/sops/age/keys.txt";
    secrets.pw_email = {};
  };

  # programs.vscode = {
  #   enable = true;
  #   package = pkgs.vscodium.fhs;
  #   # extensions = with pkgs.vscode-extensions; [
  #   #   vscodevim.vim
  #   # ];
  # };

  modules.librewolf.enable = true;

  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than 30d";
  };

  home.packages = with pkgs; [
    neofetch

    htop

    # sound input/output control
    pavucontrol
    # file manager
    nemo
    vscodium.fhs
    firefox

    obs-studio
    openshot-qt
    vlc
    loupe
    termusic
    calcure

    # tldr pages
    tealdeer

    anki
    super-productivity

    # fonts
    ipafont # japanese
    kochi-substitute # japanese
  ];

  home.username = userSettings.userName;
  home.homeDirectory = "/home" + ("/" + userSettings.userName);

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
