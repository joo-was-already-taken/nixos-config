{ pkgs, userSettings, ... }@args:
let
  sessionVariables = {
    EDITOR = "nvim";
    MANPAGER = "nvim --remote -c 'Man!' -o -";
    FILEMANAGER = "nemo";
    TERMINAL = "alacritty";
    BROWSER = "qutebrowser";

    # TODO
    NIXOS_OZONE_WL = "1";
  };
in {
  imports = [
    ../../styling/stylix.nix
    (import ../../user-modules/sh (args // { inherit sessionVariables; }))
    ../../user-modules/bluetooth.nix
    ../../user-modules/apps/qutebrowser/qutebrowser.nix
    ../../user-modules/apps/librewolf.nix
    ../../user-modules/apps/alacritty.nix
    ../../user-modules/apps/nvim/nvim.nix
    ../../user-modules/apps/tmux/tmux.nix
    (import ../../user-modules/wm/hyprland (args // { inherit sessionVariables; }))
    ../../user-modules/wm/waybar/waybar.nix
    ../../user-modules/wm/rofi
  ];

  nixpkgs.config.allowUnfreePredicate = _: true;

  # TODO: modularize
  programs.git = {
    enable = true;
    userName = "joo-was-already-taken";
    userEmail = "trackpointus@protonmail.com";
  };
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhs;
  };
  # gtk = {
  #   enable = true;
  #   theme = {
  #     name = "Breeze-Dark";
  #     package = pkgs.libsForQt5.breeze-gtk;
  #   };
  #   gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
  # };
  # qt = {
  #   enable = true;
  #   platformTheme.name = "gtk";
  #   # style = {
  #   #   name = "gtk2";
  #   #   package = pkgs.libsForQt5.breeze-qt5;
  #   # };
  # };
  # home.pointerCursor.package = lib.mkForce pkgs.capitaine-cursors-themed;
  # home.pointerCursor.name = lib.mkForce "Capitaine Cursors (Gruvbox) - White";
  # # home.pointerCursor.size = 24;
  # home.pointerCursor.x11.enable = true;
  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than 30d";
  };


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

  home.packages = with pkgs; [
    zathura
    networkmanagerapplet
    pavucontrol
    cinnamon.nemo
  ];

  # stylix.targets.gtk.enable = false;
  gtk = {
    enable = true;
    # theme = lib.mkForce { # override stylix
    #   name = "Gruvbox-Green-Dark";
    #   package = pkgs.gruvbox-gtk-theme.override {
    #     colorVariants = [ "dark" ];
    #     # themeVariants = [ "green" ];
    #   };
    # };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override {
        color = "black";
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
