{ pkgs, lib, config, userSettings, inputs, sessionVariables ? {}, ... }@args:
let
  workSessionVars = {
    EDITOR = "nvim";
    MANPAGER = "nvim --remote -c 'Man!' -o -";
    FILEMANAGER = "nemo";
    TERMINAL = "ghostty";
    BROWSER = "qutebrowser";
  }
    // (if config.modules.hyprland.enable then { NIXOS_OZONE_WL = "1"; } else {})
    // sessionVariables;

  styleSettings = import ../../styling/current-settings.nix;
in {
  imports = [
    ../../styling/home-style.nix
    inputs.sops-nix.homeManagerModules.sops
    (import ../../user-modules/sh <| args // { sessionVariables = workSessionVars; })
    ../../user-modules/dev.nix
    ../../user-modules/bluetooth.nix
    ../../user-modules/virtualization.nix
    (import ../../user-modules/apps <| args // { inherit styleSettings; })
    (import ../../user-modules/wm <| args // { sessionVariables = workSessionVars; })
  ];

  modules.vscode.java.enable = true; # :(
  modules.vscode.jupyter.enable = true;
  modules.librewolf.enable = true;

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
      temp-day = lib.mkForce 5700;
      temp-night = lib.mkForce 3300;
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

  nix = {
    gc = {
      automatic = true;
      frequency = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  home.packages = with pkgs; [
    cpulimit

    openrazer-daemon
    polychromatic

    neofetch

    htop
    pdfgrep

    # sound input/output control
    pavucontrol
    # file manager
    nemo

    obs-studio
    # openshot-qt
    vlc
    gthumb
    calcure

    # tldr pages
    tealdeer

    anki
    super-productivity

    # fonts
    ipafont # japanese
    kochi-substitute # japanese

    jetbrains-toolbox
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "jetbrains-toolbox"
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
