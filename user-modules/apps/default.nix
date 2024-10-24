{ lib, ... }:

{
  imports = [
    ./nvim
    ./tmux
    ./qutebrowser
    ./alacritty.nix
    ./librewolf.nix
    ./git.nix
    ./office.nix
  ];

  modules = {
    nvim.enable = lib.mkDefault true;
    tmux.enable = lib.mkDefault true;
    qutebrowser.enable = lib.mkDefault true;
    alacritty.enable = lib.mkDefault true;
    git.enable = lib.mkDefault true;
    office.enable = lib.mkDefault true;

    librewolf.enable = lib.mkDefault false;
  };
}
