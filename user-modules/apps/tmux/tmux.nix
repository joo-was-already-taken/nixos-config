{ pkgs, ... }:

{
  programs.tmux.enable = true;
  home.file.".config/tmux".source = ./.;
}
