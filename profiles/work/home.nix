{ config, pkgs, lib, userSettings, ... }:

{

  imports = [
    ../../styling/stylix.nix
    ../../user-modules/sh.nix
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


  # Home Manager needs a bit of information about you and the paths it should
  # manage.
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

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    zathura
    hello
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/joo/etc/profile.d/hm-session-vars.sh
  #
  # home.sessionVariables = {
  #   EDITOR = "neovim";
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
