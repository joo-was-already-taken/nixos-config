{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # python
    poetry
    python313

    # haskell
    ghc
    
    # prolog
    swiProlog
  ];
}
