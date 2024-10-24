{ pkgs, config, userSettings, inputs, ... }@args:
let
  sessionVariables = {
    EDITOR = "nvim";
    MANPAGER = "nvim --remote -c 'Man!' -o -";
    FILEMANAGER = "nemo";
    TERMINAL = "alacritty";
    BROWSER = "qutebrowser";
  } // (if config.modules.hyprland.enable then { NIXOS_OZONE_WL = "1"; } else {});
in {
  imports = [
    ../../styling/home-style.nix
    inputs.sops-nix.homeManagerModules.sops
    (import ../../user-modules/sh (args // { inherit sessionVariables; }))
    ../../user-modules/dev.nix
    ../../user-modules/bluetooth.nix
    ../../user-modules/apps
    (import ../../user-modules/wm (args // { inherit sessionVariables; }))
  ];

  # nixpkgs.config.allowUnfreePredicate = _: true;

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "/home/${userSettings.userName}/.config/sops/age/keys.txt";
    secrets.pw_email = {};
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhs;
  };

  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than 30d";
  };

  home.packages = with pkgs; [
    # sound input/output control
    pavucontrol
    # file manager
    cinnamon.nemo
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
