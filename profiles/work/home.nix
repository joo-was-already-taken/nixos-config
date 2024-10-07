{ config, pkgs, lib, userSettings, ... }@args:
let
  sessionVariables = {
    EDITOR = "nvim";
    MANPAGER = "nvim --remote -c 'Man!' -o -";
    FILEMANAGER = "dolphin";
  };
in {
  imports = [
    ../../styling/stylix.nix
    (import ../../user-modules/sh.nix (args // { inherit sessionVariables; }))
    ../../user-modules/apps/dolphin.nix
    ../../user-modules/apps/qutebrowser/qutebrowser.nix
    ../../user-modules/apps/librewolf.nix
    ../../user-modules/apps/alacritty.nix
    ../../user-modules/apps/nvim/nvim.nix
    ../../user-modules/apps/tmux/tmux.nix
    ../../user-modules/wm/hyprland/hyprland.nix
    ../../user-modules/wm/waybar/waybar.nix
    ../../user-modules/wm/rofi/rofi.nix
  ];

  nixpkgs.config.allowUnfreePredicate = _: true;

  # TODO: modularize
  programs.git = {
    enable = true;
    userName = "joo-was-already-taken";
    userEmail = "trackpointus@protonmail.com";
  };
  # home.pointerCursor.package = lib.mkForce pkgs.capitaine-cursors-themed;
  # home.pointerCursor.name = lib.mkForce "Capitaine Cursors (Gruvbox) - White";
  # # home.pointerCursor.size = 24;
  # home.pointerCursor.x11.enable = true;


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
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
