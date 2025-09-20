{ lib, myLib, ... }@args:

{
  imports = myLib.importAll args [
    ./nvim
    ./emacs
    ./tmux
    ./music
    ./alacritty.nix
    ./ghostty.nix
    ./qutebrowser.nix
    ./librewolf.nix
    ./git.nix
    ./office.nix
    ./nemo.nix
    ./vscode.nix
  ];

  modules = {
    nvim.enable = lib.mkDefault true;
    emacs.enable = lib.mkDefault true;
    music.enable = lib.mkDefault true;
    tmux.enable = lib.mkDefault true;
    ghostty.enable = lib.mkDefault true;
    qutebrowser.enable = lib.mkDefault true;
    git.enable = lib.mkDefault true;
    office.enable = lib.mkDefault true;
    nemo.enable = lib.mkDefault true;
    vscode = {
      enable = lib.mkDefault true;
      java.enable = lib.mkDefault false;
      jupyter.enable = lib.mkDefault false;
    };

    librewolf.enable = lib.mkDefault false;
    alacritty.enable = lib.mkDefault false;
  };
}
