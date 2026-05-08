{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # python
    (python314.withPackages (ps: with ps; [
      matplotlib
      numpy
      scipy
    ]))

    # linux c man pages
    man-pages
  ];
}
