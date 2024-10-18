{ lib, ... }:

{
  imports = [
    ./nvim
    ./tmux
    ./qutebrowser
    ./alacritty.nix
    ./librewolf.nix
  ];

  modules = {
    nvim.enable = lib.mkDefault true;
    tmux.enable = lib.mkDefault true;
    qutebrowser.enable = lib.mkDefault true;
    alacritty.enable = lib.mkDefault true;

    librewolf.enable = lib.mkDefault false;
  };
}
