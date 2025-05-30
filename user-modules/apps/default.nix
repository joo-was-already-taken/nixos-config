{ lib, myLib, ... }@args:

{
  imports = myLib.importAll args [
    ./nvim
    ./tmux
    ./alacritty.nix
    ./ghostty.nix
    ./qutebrowser.nix
    ./librewolf.nix
    ./git.nix
    ./office.nix
    ./vscode.nix
  ];

  modules = {
    nvim.enable = lib.mkDefault true;
    tmux.enable = lib.mkDefault true;
    alacritty.enable = lib.mkDefault false;
    ghostty.enable = lib.mkDefault true;
    qutebrowser.enable = lib.mkDefault true;
    git.enable = lib.mkDefault true;
    office.enable = lib.mkDefault true;
    vscode = {
      enable = lib.mkDefault true;
      java.enable = lib.mkDefault false;
      jupyter.enable = lib.mkDefault false;
    };

    librewolf.enable = lib.mkDefault false;
  };
}
