{ pkgs, lib, config, ... }:

{
  home.packages = with pkgs; [
    # telescope
    ripgrep
    fd
    # treesitter
    gcc
    # mason
    unzip
    nodejs_22
    cargo

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
  # home.file.".config/nvim/lua/plugins/stylix.lua".source = config.lib.stylix.colors {
  #   template = builtins.readFile ./lua/plugins/stylix.lua.mustache;
  #   extension = ".lua";
  # };
}
