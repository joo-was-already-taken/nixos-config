{ pkgs, lib, config, userSettings, inputs, ... }@args:
let
  passedSessionVars = args.sessionVariables or {};
  sessionVariables = {
    EDITOR = "nvim";
    MANPAGER = "nvim --remote -c 'Man!' -o -";
    FILEMANAGER = "nemo";
    TERMINAL = "ghostty";
    BROWSER = "qutebrowser";
  }
    // (if config.modules.hyprland.enable then { NIXOS_OZONE_WL = "1"; } else {})
    // passedSessionVars;

  styleSettings = import ../../styling/current-settings.nix;
in {
  imports = [
    ../../styling/home-style.nix
    inputs.sops-nix.homeManagerModules.sops
    (import ../../user-modules/sh (args // { inherit sessionVariables; }))
    ../../user-modules/dev.nix
    ../../user-modules/bluetooth.nix
    ../../user-modules/virtualization.nix
    (import ../../user-modules/apps (args // { inherit styleSettings sessionVariables; }))
    (import ../../user-modules/wm (args // { inherit sessionVariables; }))
  ];

  modules.librewolf.enable = true;

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = let
        pdf = [ "zathura.desktop" ];
        browser = [ "qutebrowser.desktop" ];
        image = [ "org.gnome.gThumb.desktop" ];
      in {
        "application/pdf" = pdf;

        "text/html" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/about" = browser;
        "x-scheme-handler/unknown" = browser;

        "image/jpeg" = image;
        "image/png" = image;
        "image/gif" = image;
        "image/webp" = image;
        "image/tiff" = image;
        "image/bmp" = image;
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

  # certain ports are open in profiles/work/configuration.nix
  # TODO: theme qt backend
  services.kdeconnect.enable = true;

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
    package = pkgs.nix;
    gc = {
      automatic = true;
      frequency = "weekly";
      options = "--delete-older-than 30d";
    };
    settings.auto-optimise-store = true;
  };

  home.packages = with pkgs; [
    cpulimit

    neofetch

    htop
    pdfgrep

    # sound input/output control
    pavucontrol

    obs-studio
    # openshot-qt
    vlc
    gthumb
    gimp

    scrcpy

    calcure

    # tldr pages
    tealdeer

    anki
    super-productivity

    freecad

    # fonts
    ipafont # japanese
    kochi-substitute # japanese

    jetbrains-toolbox

    typst

    # mkfs commands
    e2fsprogs

    transmission_4-gtk

    # TODO: use stable in 25.11
    (unstable.winboat.overrideAttrs (old: {
      # doesn't build without this
      npmFlags = old.npmFlags or [] ++ [ "--legacy-peer-deps" ];
    }))

    just
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
