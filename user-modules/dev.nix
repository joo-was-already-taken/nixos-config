{ pkgs, ... }:

{
  home.packages = with pkgs; [
    poetry
    python313

    ghc
  ];
}
