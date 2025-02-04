{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # python
    poetry
    python313

    # go
    go

    # haskell
    ghc
    
    # prolog
    swi-prolog
  ];
}
