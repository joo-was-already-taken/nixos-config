{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # telescope
    ripgrep
    fd
    # treesitter
    gcc
    # mason
    unzip

    yaml-language-server
  ];

  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
  home.file.".config/nvim" = {
    source = ./.;
    recursive = true;
  };
}
